From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 16/19] x86/resctrl: release rdtgroup_mutex and the CPU hotplug lock in rdt_shutdown_sb
Date: Wed, 13 Sep 2023 08:10:10 -0300
Message-ID: <20230913111013.77623-17-hch@lst.de>
References: <20230913111013.77623-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=Q2VwcKDbn0sssCtg/tKvOFfISdo7sbQlCa3jWeP0g5o=; b=U9maC0r9MMAGiR+QOYQXHrPmxl
        hylGpcYyRZf8wlnfYzYJRGZ+ePuUrLXyBiCBj233USe8FtvXKcesNUnc6ymEuNNxot0H1zdTdIqxD
        4nZemSt5Xe+moQ3awKBJ0JWFY7hKqY5a8qTbBzA4Chr1Z80FIM12zzh+M3AcEb9HxFS5iSZondHRZ
        WQoy1PvwkQqXEgFPHOyK0Z5obK/hYR6g0WWqUFEQshG2lS0WzKwVP/zoNBlJqjuwTFZxNoSSi1ufm
        2tnBrbQ85MVzRjetu64lwiuth4qM5dROCJK8uHKhfCxDaBwLEfj6vTmeG7EfaLoILEr/TxmwYoAQM
        bOsLTfDQ==;
In-Reply-To: <20230913111013.77623-1-hch-jcswGhMUV9g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Cc: Heiko Carstens <hca-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Vasily Gorbik <gor-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Alexander Gordeev <agordeev-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Fenghua Yu <fenghua.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Reinette Chatre <reinette.chatre-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Miquel Raynal <miquel.raynal-LDxbnhwyfcJBDgjK7y7TUQ@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Vignesh Raghavendra <vigneshr-l0cyMroinI0@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ntyVByD3zXaTtA8H5PvdGFaTQe2KTcn/@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Trond Myklebust <trond.myklebust-F/q8l9xzQnoyLce1RVWEUA@public.gmane.org>, Anna Schumaker <anna-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Damien Le Moal <dlemoal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Naohiro Aota <naohiro.aota-Sjgp3cTcYWE@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

While the resctl code is a bit confusing, I can't find anything protected
by rdtgroup_mutex or the CPU hotplug lock in generic_shutdown_super or
kernfs_free_sb.  Drop the locks at the end of rdt_shutdown_sb to avoid
holding locks over method calls and VFS code which itself already has a
rather complicated locking hierarchy.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 arch/x86/kernel/cpu/resctrl/rdtgroup.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
index 8db767fd80df6b..e87de519493021 100644
--- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
+++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
@@ -2793,11 +2793,6 @@ static void rdt_shutdown_sb(struct super_block *sb)
 	static_branch_disable_cpuslocked(&rdt_mon_enable_key);
 	static_branch_disable_cpuslocked(&rdt_enable_key);
 	kernfs_shutdown_sb(sb);
-}
-
-static void rdt_free_sb(struct super_block *sb)
-{
-	kernfs_free_sb(sb);
 	mutex_unlock(&rdtgroup_mutex);
 	cpus_read_unlock();
 }
@@ -2807,7 +2802,7 @@ static struct file_system_type rdt_fs_type = {
 	.init_fs_context	= rdt_init_fs_context,
 	.parameters		= rdt_fs_parameters,
 	.shutdown_sb		= rdt_shutdown_sb,
-	.free_sb		= rdt_free_sb,
+	.free_sb		= kernfs_free_sb,
 };
 
 static int mon_addfile(struct kernfs_node *parent_kn, const char *name,
-- 
2.39.2

