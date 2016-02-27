#include "controller.h"
#include "../model/material.h"

/// Constructors and destructors
void controller_init(Controller *self, Repository *repo) {
    self->repo = repo;
}

void controller_destroy(Controller *self){
    free(self);
    self = NULL;
}

/// Public
vector *controller_getMaterials(Controller *self) {
    return repo_getMaterials(self->repo);
}

int controller_addMaterial(Controller *self, Material m){
    if(repo_findMaterial(self->repo, m) == 1) {
        vector *arr;
        arr = controller_getMaterials(self);
        int n = vector_getLen(arr), i;
        for(i = 0 ; i < n ; ++ i) {
            Material act = vector_getAt(arr, i);
            if(material_equal(&act, &m)) {
                act.quantity += m.quantity;
                vector_setAt(arr, i, act);
                return 0;
            }
        }
    }
    repo_addMaterial(self->repo, m);
    return 1;
}

int controller_deleteMaterial(Controller *self, Material m) {
    if(repo_findMaterial(self->repo, m) == 0)
        return 0;
    repo_deleteMaterial(self->repo, m);
    return 1;
}

int controller_updateMaterial(Controller *self, Material m) {
    if(repo_findMaterial(self->repo, m) == 0)
        return 0;
    repo_updateMaterial(self->repo, m);
    return 1;
}
