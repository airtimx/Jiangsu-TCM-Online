package com.jiangsu.tcm.module.user.support;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import org.springframework.stereotype.Component;

@Component
public class ImportErrorFileStore {

    private final Map<Long, byte[]> store = new ConcurrentHashMap<>();

    public void put(Long batchId, byte[] content) {
        store.put(batchId, content);
    }

    public byte[] get(Long batchId) {
        return store.get(batchId);
    }
}
