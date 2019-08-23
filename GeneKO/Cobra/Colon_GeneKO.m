% EssentialGenes.m
clear; clc;


% Input the core model
model1=readSBML('./NCI60_SBML_models/COLO-205.xml',1000);
model2=readSBML('./NCI60_SBML_models/HCC2998.xml',1000);
model3=readSBML('./NCI60_SBML_models/HCT-116.xml',1000);
model4=readSBML('./NCI60_SBML_models/HCT-15.xml',1000);
model5=readSBML('./NCI60_SBML_models/HT29.xml',1000);
model6=readSBML('./NCI60_SBML_models/KM12.xml',1000);
model7=readSBML('./NCI60_SBML_models/SW620.xml',1000);

% Create list of models and cell lines
% All cell line names must be same length in order to create table

models = [model1, model2, model3, model4, model5, model6, model7];
names = ['COLO-205','HCC2998 ','HCT-116 ','HCT-15 ','HT29    ','KM12    ','SW6210   '];

tol = 1e-6; % Growth rate lower limit

%Create list of gene IDs
genelist=model1.genes;
genelistrounded=(floor(str2double(genelist)));
%writetable(table(unique(genelistrounded),'stable'),'CNS_GeneList.csv');

k = length(models);
FullTable = {};

n=1;
for i = 1:k
    % get growth rate ratio for gene KO
    grRatio = singleGeneDeletion(models(i));
    grRatio(isnan(grRatio))=0;
    gr_list(1,:)=grRatio;
    
    % create list of cell lines equal to length of genes    
    CL    = cell(length(genelistrounded),1);
    % cell line name is from n to n+x
    CL(:) = {names(n:n+7)};
        
    % create gene ko table with list of genes, grRatio and cell line
    ko = table(genelistrounded,grRatio,CL);
    % get rid of duplicate genes
    ko_unq = unique(ko,'stable');
    
    %add data from each cell line to table
    FullTable=[FullTable;ko_unq];
    n=n+8;
end

%write entire table to csv file
writetable(FullTable,'./Gene KO Tables/Colon Gene Knockout Table.csv')


