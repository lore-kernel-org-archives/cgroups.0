From: Daniel Xu <dxu@dxuuu.xyz>
Subject: [PATCH 2/2] cgroupfs: Support user xattrs
Date: Mon,  2 Mar 2020 17:39:01 -0800
Message-ID: <20200303013901.32150-3-dxu@dxuuu.xyz>
References: <20200303013901.32150-1-dxu@dxuuu.xyz>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=
        from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=fm2; bh=jkpN0tE9kbjSg
        rzQw7RM0dDUJhBDaut1bqepPcL8VGQ=; b=AUHCEfaOED4Ro11FFbK7kojSeiiFt
        XPJv/iXDh7hgB6yKgzW+75evX4zqa3gp4C8zOIu7kFNbXDG5g1E/ETyG58bq6dQ/
        bYirfaLj5jvfQbw8ED4sYs6B+LYaO5M81sZ9ZbQe7ZqFgPdw2CrrFM+v1zSfkRJa
        zsRjm/v64KvoBUBxXIhVpcjHgzmXZ/QsQKonqziihMezsrNB3LOWOwdYVS4TJdEV
        ujK2TBEGbtaqs9QwcLvCSh3QEOcf84SmlqUyvSO2HJ4hDlqE051naUGM1NDX5zcC
        Pk4CT0AD311SNo70ymQxhHHQVbUN5P6Vvp07Pohvjw8lEuEJuwHigKXDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=jkpN0tE9kbjSgrzQw7RM0dDUJhBDaut1bqepPcL8VGQ=; b=W6exJ0OC
        toP4CNsLpiNs7ZsqYeZAg/I/B8ennpLkccKKs0PXhU3anKgQ4Yy+2b4eTv6zROtR
        x4hWR5btEsAlzYbHqsHra+lhBJpauGeRoXo1L+smId/q0n6XoL0pDRU1RDtZtLIn
        VkDf7tu2xQXcDiv8ZlwKgfKxA9m8ur2Pvjn9yeFNdru6gS3V0aD22S/zQkT2FKVP
        uhO2isK0fP6gyz6P6YHctI5IXV6eoVA2JCDyY7hveyzz7ZDNrnhg3WFLM2QlmyGn
        Udtfm8edNvbHNybezr5i8h3r3n3by9oqpsaZGZXAG+QqN7yhWJhRTj2AnXSVjDqS
        zZlmNOgwfn6CWA==
In-Reply-To: <20200303013901.32150-1-dxu@dxuuu.xyz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: cgroups@vger.kernel.org, tj@kernel.org, lizefan@huawei.com, hannes@cmpxchg.org
Cc: Daniel Xu <dxu@dxuuu.xyz>, linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org, kernel-team@fb.com

This patch turns on xattr support for cgroupfs. This is useful for
letting non-root owners of delegated subtrees attach metadata to
cgroups.

One use case is for subtree owners to tell a userspace out of memory
killer to bias away from killing specific subtrees.

Tests:

    [/sys/fs/cgroup]# for i in $(seq 0 130); \
        do setfattr workload.slice -n user.name$i -v wow; done
    setfattr: workload.slice: No space left on device
    setfattr: workload.slice: No space left on device
    setfattr: workload.slice: No space left on device

    [/sys/fs/cgroup]# for i in $(seq 0 130); \
        do setfattr workload.slice --remove user.name$i; done
    setfattr: workload.slice: No such attribute
    setfattr: workload.slice: No such attribute
    setfattr: workload.slice: No such attribute

    [/sys/fs/cgroup]# for i in $(seq 0 130); \
        do setfattr workload.slice -n user.name$i -v wow; done
    setfattr: workload.slice: No space left on device
    setfattr: workload.slice: No space left on device
    setfattr: workload.slice: No space left on device

`seq 0 130` is inclusive, and 131 - 128 = 3, which is the number of
errors we expect to see.

Signed-off-by: Daniel Xu <dxu@dxuuu.xyz>
---
 kernel/cgroup/cgroup.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 75f687301bbf..21621b43a8ab 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -1954,7 +1954,8 @@ int cgroup_setup_root(struct cgroup_root *root, u16 ss_mask)
 
 	root->kf_root = kernfs_create_root(kf_sops,
 					   KERNFS_ROOT_CREATE_DEACTIVATED |
-					   KERNFS_ROOT_SUPPORT_EXPORTOP,
+					   KERNFS_ROOT_SUPPORT_EXPORTOP |
+					   KERNFS_ROOT_SUPPORT_USER_XATTR,
 					   root_cgrp);
 	if (IS_ERR(root->kf_root)) {
 		ret = PTR_ERR(root->kf_root);
-- 
2.21.1

