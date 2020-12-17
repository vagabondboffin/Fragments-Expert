function [ErrorMsg,Dataset,FeatureLabels,ClassLabels,Function_Select] = Select_SubDataset_FFC(Dataset,FeatureLabels,ClassLabels,Function_Select)

% This function takes Dataset and selects subset of Dataset. Subset can be
% taken as sub-features or sub-classes (or both).
%
% Copyright (C) 2020 Mehdi Teimouri <mehditeimouri [at] ut.ac.ir>
%
% This file is a part of Fragments-Expert software, a software package for
% feature extraction from file fragments and classification among various file formats.
%
% Fragments-Expert software is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License
% as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
%
% Fragments-Expert software is distributed in the hope that it will be useful,but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License along with this program.
% If not, see <http://www.gnu.org/licenses/>.
%
% Inputs:
%   Dataset: Dataset with L rows (L samples corresponding to L fragments)
%       and C columns. The first C-2 columns correspond to features.
%       The last two columns correspond to the integer-valued class labels
%       and the FileID of the fragments, respectively.
%   FeatureLabels: 1xF cell. Cell contents are strings denoting the name of
%       features corresponding to the columns of Dataset.
%   ClassLabels: 1xM cell. Cell contents are strings denoting the name of
%       classes corresponding to integer-valued class labels 1,2,....
%   Function_Select: Cell array of selected features after feature
%       calculation. This cell array contains C-2 logival values true.
%
% Outputs:
%   ErrorMsg: Possible error message. If there is no error, this output is
%   empty.
%   Dataset: Dataset with Lp rows (Lp samples corresponding to Lp fragments)
%       and C columns. The first Cp-2 columns correspond to features.
%       The last two columns correspond to the integer-valued class labels
%       and the FileID of the fragments, respectively.
%   FeatureLabels: 1xFp cell. Cell contents are strings denoting the name of
%       features corresponding to the columns of Dataset.
%   ClassLabels: 1xMp cell. Cell contents are strings denoting the name of
%       classes corresponding to integer-valued class labels 1,2,....
%   Function_Select: Cell array of selected features after feature calculation. 
%       This cell array contains C-p2 logival values true.
%
%   Note: In Dataset and MergedDataset, First, the samples of class 1 appear.
%   Second, the the samples of class 2 appear, and so on. Also, for the samples
%   of each class, the fragments of a signle multimedia file appear consecutively.
%
% Revisions:
% 2020-Mar-05   function was created

%% Select Sub-Classes
[ErrorMsg,ClassSel,~] = Select_from_List_FFC(ClassLabels,1,'Select classes to be included');
if ~isempty(ErrorMsg)
    return;
end
ClassSel = ClassSel{1};

%% Select Sub-Features
[ErrorMsg,FeatSel,~] = Select_from_List_FFC(FeatureLabels,1,'Select features to be included');
if ~isempty(ErrorMsg)
    return;
end
FeatSel = FeatSel{1};

%% Select Sub-Features
Dataset = Dataset(:,[FeatSel end-1:end]);
FeatureLabels = FeatureLabels(FeatSel);
cnt = 0;
for i=1:length(Function_Select)
    for j=1:length(Function_Select{i})
        if Function_Select{i}(j)
            cnt = cnt+1;
            if all(FeatSel~=cnt)
                Function_Select{i}(j) = false;
            end
        end
    end
end

%% Select Sub-Classes
ClassSel = sort(ClassSel);
ClassLabels = ClassLabels(ClassSel);
for i=1:size(Dataset,1)
    c = Dataset(i,end-1);
    idx = find(ClassSel==c);
    
    if ~isempty(idx)
        Dataset(i,end-1) = idx(1);
    else
        Dataset(i,end-1) = -1;
    end
end
Dataset = Dataset(Dataset(:,end-1)~=-1,:);