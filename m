From: Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: [RFC PATCH 17/19] mm: Convert mmap and mlock to use account_locked_vm
Date: Tue, 24 Jan 2023 16:42:46 +1100
Message-ID: <767bef7ec4e26a2a9655d9c7e8bad8d1255944f5.1674538665.git-series.apopple@nvidia.com>
References: <cover.f52b9eb2792bccb8a9ecd6bc95055705cfe2ae03.1674538665.git-series.apopple@nvidia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UULxjfjg3cKi8O85puJF65UHMaoo5iv3EW5HbTo5aKQ=;
 b=UW35PYbei4yr1W/izxJ+bccnl3ihFG9XMEGdPYQeGdYj+if1pTtZR/dgHNf2U7matzXnpi5N34uFQC+lHVieFo7EguFy9rVV38TbQI8CP+k5D/b98w+4PtIDfJr3kZybo8rov96obveOxpuBxznA5rYPAA+ja1pmUCz7Dn/UZur36JfEKqOCel5bnIgEASiEF+gJbwpd7XXbHlTfEZ6MG1n2wtb2zs4VgfspAyakvRJp15T5dBFEq+jcNdSn4/d4XU3w+VyKwf2h/u/nBXTzmykLoi4SA/j3a+eGQtXQ24F12rMQV8UOXZY//6T8RXGHjZcvLucP9mFEiADqvFlrsA==
In-Reply-To: <cover.f52b9eb2792bccb8a9ecd6bc95055705cfe2ae03.1674538665.git-series.apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, daniel-/w4YWyX8dFk@public.gmane.org, Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>

A future change introduces a cgroup to control the amount of
locked/pinned memory on the system. To ensure memory pinned via mlock
and mmap is accounted for use the common account_locked_vm()
function.

As cgroups can outlive individual processes also unaccount for the
locked memory during process teardown.

This patch should introduce no user visible change.

Signed-off-by: Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 mm/internal.h  |  2 +-
 mm/mlock.c     | 76 ++++++++++-----------------------------------------
 mm/mmap.c      | 76 +++++++++++++++++++++++++--------------------------
 mm/mremap.c    | 54 ++++++++++++++++++++++++++----------
 mm/secretmem.c |  6 +---
 5 files changed, 95 insertions(+), 119 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index bcf75a8..7c8c3f2 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -489,8 +489,6 @@ extern long populate_vma_page_range(struct vm_area_struct *vma,
 extern long faultin_vma_page_range(struct vm_area_struct *vma,
 				   unsigned long start, unsigned long end,
 				   bool write, int *locked);
-extern int mlock_future_check(struct mm_struct *mm, unsigned long flags,
-			      unsigned long len);
 /*
  * mlock_vma_page() and munlock_vma_page():
  * should be called with vma's mmap_lock held for read or write,
diff --git a/mm/mlock.c b/mm/mlock.c
index 7032f6d..a97c8c5 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -416,6 +416,20 @@ static int mlock_fixup(struct vm_area_struct *vma, struct vm_area_struct **prev,
 		/* don't set VM_LOCKED or VM_LOCKONFAULT and don't count */
 		goto out;
 
+	/*
+	 * Keep track of amount of locked VM.
+	 */
+	nr_pages = (end - start) >> PAGE_SHIFT;
+	if (!(newflags & VM_LOCKED)) {
+		__unaccount_locked_vm(mm, nr_pages);
+	} else if (!(oldflags & VM_LOCKED)) {
+		if (__account_locked_vm(mm, nr_pages, current,
+						capable(CAP_IPC_LOCK))) {
+			ret = -ENOMEM;
+			goto out;
+		}
+	}
+
 	pgoff = vma->vm_pgoff + ((start - vma->vm_start) >> PAGE_SHIFT);
 	*prev = vma_merge(mm, *prev, start, end, newflags, vma->anon_vma,
 			  vma->vm_file, pgoff, vma_policy(vma),
@@ -439,16 +453,6 @@ static int mlock_fixup(struct vm_area_struct *vma, struct vm_area_struct **prev,
 
 success:
 	/*
-	 * Keep track of amount of locked VM.
-	 */
-	nr_pages = (end - start) >> PAGE_SHIFT;
-	if (!(newflags & VM_LOCKED))
-		nr_pages = -nr_pages;
-	else if (oldflags & VM_LOCKED)
-		nr_pages = 0;
-	mm->locked_vm += nr_pages;
-
-	/*
 	 * vm_flags is protected by the mmap_lock held in write mode.
 	 * It's okay if try_to_unmap_one unmaps a page just after we
 	 * set VM_LOCKED, populate_vma_page_range will bring it back.
@@ -517,42 +521,6 @@ static int apply_vma_lock_flags(unsigned long start, size_t len,
 }
 
 /*
- * Go through vma areas and sum size of mlocked
- * vma pages, as return value.
- * Note deferred memory locking case(mlock2(,,MLOCK_ONFAULT)
- * is also counted.
- * Return value: previously mlocked page counts
- */
-static unsigned long count_mm_mlocked_page_nr(struct mm_struct *mm,
-		unsigned long start, size_t len)
-{
-	struct vm_area_struct *vma;
-	unsigned long count = 0;
-	unsigned long end;
-	VMA_ITERATOR(vmi, mm, start);
-
-	/* Don't overflow past ULONG_MAX */
-	if (unlikely(ULONG_MAX - len < start))
-		end = ULONG_MAX;
-	else
-		end = start + len;
-
-	for_each_vma_range(vmi, vma, end) {
-		if (vma->vm_flags & VM_LOCKED) {
-			if (start > vma->vm_start)
-				count -= (start - vma->vm_start);
-			if (end < vma->vm_end) {
-				count += end - vma->vm_start;
-				break;
-			}
-			count += vma->vm_end - vma->vm_start;
-		}
-	}
-
-	return count >> PAGE_SHIFT;
-}
-
-/*
  * convert get_user_pages() return value to posix mlock() error
  */
 static int __mlock_posix_error_return(long retval)
@@ -585,21 +553,7 @@ static __must_check int do_mlock(unsigned long start, size_t len, vm_flags_t fla
 	if (mmap_write_lock_killable(current->mm))
 		return -EINTR;
 
-	locked += current->mm->locked_vm;
-	if ((locked > lock_limit) && (!capable(CAP_IPC_LOCK))) {
-		/*
-		 * It is possible that the regions requested intersect with
-		 * previously mlocked areas, that part area in "mm->locked_vm"
-		 * should not be counted to new mlock increment count. So check
-		 * and adjust locked count if necessary.
-		 */
-		locked -= count_mm_mlocked_page_nr(current->mm,
-				start, len);
-	}
-
-	/* check against resource limits */
-	if ((locked <= lock_limit) || capable(CAP_IPC_LOCK))
-		error = apply_vma_lock_flags(start, len, flags);
+	error = apply_vma_lock_flags(start, len, flags);
 
 	mmap_write_unlock(current->mm);
 	if (error)
diff --git a/mm/mmap.c b/mm/mmap.c
index 425a934..2c05582 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -160,7 +160,7 @@ static int check_brk_limits(unsigned long addr, unsigned long len)
 	if (IS_ERR_VALUE(mapped_addr))
 		return mapped_addr;
 
-	return mlock_future_check(current->mm, current->mm->def_flags, len);
+	return 0;
 }
 static int do_brk_munmap(struct ma_state *mas, struct vm_area_struct *vma,
 			 unsigned long newbrk, unsigned long oldbrk,
@@ -1184,23 +1184,6 @@ static inline unsigned long round_hint_to_min(unsigned long hint)
 	return hint;
 }
 
-int mlock_future_check(struct mm_struct *mm, unsigned long flags,
-		       unsigned long len)
-{
-	unsigned long locked, lock_limit;
-
-	/*  mlock MCL_FUTURE? */
-	if (flags & VM_LOCKED) {
-		locked = len >> PAGE_SHIFT;
-		locked += mm->locked_vm;
-		lock_limit = rlimit(RLIMIT_MEMLOCK);
-		lock_limit >>= PAGE_SHIFT;
-		if (locked > lock_limit && !capable(CAP_IPC_LOCK))
-			return -EAGAIN;
-	}
-	return 0;
-}
-
 static inline u64 file_mmap_size_max(struct file *file, struct inode *inode)
 {
 	if (S_ISREG(inode->i_mode))
@@ -1310,9 +1293,6 @@ unsigned long do_mmap(struct file *file, unsigned long addr,
 		if (!can_do_mlock())
 			return -EPERM;
 
-	if (mlock_future_check(mm, vm_flags, len))
-		return -EAGAIN;
-
 	if (file) {
 		struct inode *inode = file_inode(file);
 		unsigned long flags_mask;
@@ -1882,22 +1862,27 @@ static int acct_stack_growth(struct vm_area_struct *vma,
 	if (size > rlimit(RLIMIT_STACK))
 		return -ENOMEM;
 
-	/* mlock limit tests */
-	if (mlock_future_check(mm, vma->vm_flags, grow << PAGE_SHIFT))
-		return -ENOMEM;
-
 	/* Check to ensure the stack will not grow into a hugetlb-only region */
 	new_start = (vma->vm_flags & VM_GROWSUP) ? vma->vm_start :
 			vma->vm_end - size;
 	if (is_hugepage_only_range(vma->vm_mm, new_start, size))
 		return -EFAULT;
 
+	/* mlock limit tests */
+	if (vma->vm_flags & VM_LOCKED)
+		if (__account_locked_vm(mm, grow << PAGE_SHIFT, current,
+						capable(CAP_IPC_LOCK)))
+			return -ENOMEM;
+
 	/*
 	 * Overcommit..  This must be the final test, as it will
 	 * update security statistics.
 	 */
-	if (security_vm_enough_memory_mm(mm, grow))
+	if (security_vm_enough_memory_mm(mm, grow)) {
+		if (vma->vm_flags & VM_LOCKED)
+			__unaccount_locked_vm(mm, grow << PAGE_SHIFT);
 		return -ENOMEM;
+	}
 
 	return 0;
 }
@@ -1975,8 +1960,6 @@ int expand_upwards(struct vm_area_struct *vma, unsigned long address)
 				 * to guard against concurrent vma expansions.
 				 */
 				spin_lock(&mm->page_table_lock);
-				if (vma->vm_flags & VM_LOCKED)
-					mm->locked_vm += grow;
 				vm_stat_account(mm, vma->vm_flags, grow);
 				anon_vma_interval_tree_pre_update_vma(vma);
 				vma->vm_end = address;
@@ -2056,8 +2039,6 @@ int expand_downwards(struct vm_area_struct *vma, unsigned long address)
 				 * to guard against concurrent vma expansions.
 				 */
 				spin_lock(&mm->page_table_lock);
-				if (vma->vm_flags & VM_LOCKED)
-					mm->locked_vm += grow;
 				vm_stat_account(mm, vma->vm_flags, grow);
 				anon_vma_interval_tree_pre_update_vma(vma);
 				vma->vm_start = address;
@@ -2281,7 +2262,7 @@ static inline int munmap_sidetree(struct vm_area_struct *vma,
 		return -ENOMEM;
 
 	if (vma->vm_flags & VM_LOCKED)
-		vma->vm_mm->locked_vm -= vma_pages(vma);
+		__unaccount_locked_vm(vma->vm_mm, vma_pages(vma));
 
 	return 0;
 }
@@ -2525,6 +2506,7 @@ unsigned long mmap_region(struct file *file, unsigned long addr,
 	struct vm_area_struct *next, *prev, *merge;
 	pgoff_t pglen = len >> PAGE_SHIFT;
 	unsigned long charged = 0;
+	unsigned long locked = 0;
 	unsigned long end = addr + len;
 	unsigned long merge_start = addr, merge_end = end;
 	pgoff_t vm_pgoff;
@@ -2560,6 +2542,15 @@ unsigned long mmap_region(struct file *file, unsigned long addr,
 		vm_flags |= VM_ACCOUNT;
 	}
 
+	if (vm_flags & VM_LOCKED) {
+		locked = len >> PAGE_SHIFT;
+		if (__account_locked_vm(mm, locked, current,
+						capable(CAP_IPC_LOCK))) {
+			error = -ENOMEM;
+			goto unacct_error;
+		}
+	}
+
 	next = mas_next(&mas, ULONG_MAX);
 	prev = mas_prev(&mas, 0);
 	if (vm_flags & VM_SPECIAL)
@@ -2605,7 +2596,7 @@ unsigned long mmap_region(struct file *file, unsigned long addr,
 	vma = vm_area_alloc(mm);
 	if (!vma) {
 		error = -ENOMEM;
-		goto unacct_error;
+		goto unlock_error;
 	}
 
 	vma->vm_start = addr;
@@ -2725,8 +2716,6 @@ unsigned long mmap_region(struct file *file, unsigned long addr,
 					is_vm_hugetlb_page(vma) ||
 					vma == get_gate_vma(current->mm))
 			vma->vm_flags &= VM_LOCKED_CLEAR_MASK;
-		else
-			mm->locked_vm += (len >> PAGE_SHIFT);
 	}
 
 	if (file)
@@ -2759,6 +2748,9 @@ unsigned long mmap_region(struct file *file, unsigned long addr,
 		mapping_unmap_writable(file->f_mapping);
 free_vma:
 	vm_area_free(vma);
+unlock_error:
+	if (locked)
+		__unaccount_locked_vm(mm, locked);
 unacct_error:
 	if (charged)
 		vm_unacct_memory(charged);
@@ -2942,8 +2934,13 @@ static int do_brk_flags(struct ma_state *mas, struct vm_area_struct *vma,
 	if (mm->map_count > sysctl_max_map_count)
 		return -ENOMEM;
 
+	if (flags & VM_LOCKED)
+		if (__account_locked_vm(mm, len >> PAGE_SHIFT, current,
+					capable(CAP_IPC_LOCK)))
+			return -ENOMEM;
+
 	if (security_vm_enough_memory_mm(mm, len >> PAGE_SHIFT))
-		return -ENOMEM;
+		goto unacct_locked;
 
 	/*
 	 * Expand the existing vma if possible; Note that singular lists do not
@@ -2993,8 +2990,6 @@ static int do_brk_flags(struct ma_state *mas, struct vm_area_struct *vma,
 	perf_event_mmap(vma);
 	mm->total_vm += len >> PAGE_SHIFT;
 	mm->data_vm += len >> PAGE_SHIFT;
-	if (flags & VM_LOCKED)
-		mm->locked_vm += (len >> PAGE_SHIFT);
 	vma->vm_flags |= VM_SOFTDIRTY;
 	validate_mm(mm);
 	return 0;
@@ -3003,6 +2998,8 @@ static int do_brk_flags(struct ma_state *mas, struct vm_area_struct *vma,
 	vm_area_free(vma);
 unacct_fail:
 	vm_unacct_memory(len >> PAGE_SHIFT);
+unacct_locked:
+	__unaccount_locked_vm(mm, len >> PAGE_SHIFT);
 	return -ENOMEM;
 }
 
@@ -3064,7 +3061,7 @@ void exit_mmap(struct mm_struct *mm)
 {
 	struct mmu_gather tlb;
 	struct vm_area_struct *vma;
-	unsigned long nr_accounted = 0;
+	unsigned long nr_accounted = 0, nr_locked = 0;
 	MA_STATE(mas, &mm->mm_mt, 0, 0);
 	int count = 0;
 
@@ -3107,6 +3104,8 @@ void exit_mmap(struct mm_struct *mm)
 	do {
 		if (vma->vm_flags & VM_ACCOUNT)
 			nr_accounted += vma_pages(vma);
+		if (vma->vm_flags & VM_LOCKED)
+			nr_locked += vma_pages(vma);
 		remove_vma(vma);
 		count++;
 		cond_resched();
@@ -3116,6 +3115,7 @@ void exit_mmap(struct mm_struct *mm)
 
 	trace_exit_mmap(mm);
 	__mt_destroy(&mm->mm_mt);
+	__unaccount_locked_vm(mm, nr_locked);
 	mmap_write_unlock(mm);
 	vm_unacct_memory(nr_accounted);
 }
diff --git a/mm/mremap.c b/mm/mremap.c
index fe587c5..67cc4f3 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -574,7 +574,7 @@ static unsigned long move_vma(struct vm_area_struct *vma,
 		bool *locked, unsigned long flags,
 		struct vm_userfaultfd_ctx *uf, struct list_head *uf_unmap)
 {
-	long to_account = new_len - old_len;
+	long to_account = (new_len - old_len) >> PAGE_SHIFT;
 	struct mm_struct *mm = vma->vm_mm;
 	struct vm_area_struct *new_vma;
 	unsigned long vm_flags = vma->vm_flags;
@@ -594,7 +594,7 @@ static unsigned long move_vma(struct vm_area_struct *vma,
 		return -ENOMEM;
 
 	if (unlikely(flags & MREMAP_DONTUNMAP))
-		to_account = new_len;
+		to_account = new_len >> PAGE_SHIFT;
 
 	if (vma->vm_ops && vma->vm_ops->may_split) {
 		if (vma->vm_start != old_addr)
@@ -618,16 +618,36 @@ static unsigned long move_vma(struct vm_area_struct *vma,
 		return err;
 
 	if (vm_flags & VM_ACCOUNT) {
-		if (security_vm_enough_memory_mm(mm, to_account >> PAGE_SHIFT))
+		if (security_vm_enough_memory_mm(mm, to_account))
 			return -ENOMEM;
 	}
 
+	/*
+	 * MREMAP_DONTUNMAP clears VM_LOCKED on the old vma and
+	 * implies new_len == old_len so no need to account locked
+	 * pages.
+	 */
+	if ((vm_flags & VM_LOCKED) && likely(!(flags & MREMAP_DONTUNMAP))) {
+		if (__account_locked_vm(mm, to_account, current,
+					capable(CAP_IPC_LOCK))) {
+			if (vm_flags & VM_ACCOUNT)
+				vm_unacct_memory(to_account);
+			return -ENOMEM;
+		}
+		*locked = true;
+	}
+
 	new_pgoff = vma->vm_pgoff + ((old_addr - vma->vm_start) >> PAGE_SHIFT);
 	new_vma = copy_vma(&vma, new_addr, new_len, new_pgoff,
 			   &need_rmap_locks);
 	if (!new_vma) {
 		if (vm_flags & VM_ACCOUNT)
-			vm_unacct_memory(to_account >> PAGE_SHIFT);
+			vm_unacct_memory(to_account);
+		if ((vm_flags & VM_LOCKED) &&
+		    likely(!(flags & MREMAP_DONTUNMAP))) {
+			__unaccount_locked_vm(mm, to_account);
+			*locked = false;
+		}
 		return -ENOMEM;
 	}
 
@@ -696,10 +716,11 @@ static unsigned long move_vma(struct vm_area_struct *vma,
 			vma->vm_end == (old_addr + old_len))
 			unlink_anon_vmas(vma);
 
-		/* Because we won't unmap we don't need to touch locked_vm */
 		return new_addr;
 	}
 
+	/* Make sure do_munmap() doesn't unaccount locked pages */
+	vma->vm_flags &= VM_LOCKED_CLEAR_MASK;
 	if (do_munmap(mm, old_addr, old_len, uf_unmap) < 0) {
 		/* OOM: unable to split vma, just get accounts right */
 		if (vm_flags & VM_ACCOUNT && !(flags & MREMAP_DONTUNMAP))
@@ -707,15 +728,11 @@ static unsigned long move_vma(struct vm_area_struct *vma,
 		excess = 0;
 	}
 
-	if (vm_flags & VM_LOCKED) {
-		mm->locked_vm += new_len >> PAGE_SHIFT;
-		*locked = true;
-	}
-
 	mm->hiwater_vm = hiwater_vm;
 
 	/* Restore VM_ACCOUNT if one or two pieces of vma left */
 	if (excess) {
+		vma->vm_flags = vm_flags;
 		vma->vm_flags |= VM_ACCOUNT;
 		if (split)
 			find_vma(mm, vma->vm_end)->vm_flags |= VM_ACCOUNT;
@@ -768,9 +785,6 @@ static struct vm_area_struct *vma_to_resize(unsigned long addr,
 	if (vma->vm_flags & (VM_DONTEXPAND | VM_PFNMAP))
 		return ERR_PTR(-EFAULT);
 
-	if (mlock_future_check(mm, vma->vm_flags, new_len - old_len))
-		return ERR_PTR(-EAGAIN);
-
 	if (!may_expand_vm(mm, vma->vm_flags,
 				(new_len - old_len) >> PAGE_SHIFT))
 		return ERR_PTR(-ENOMEM);
@@ -1026,6 +1040,16 @@ SYSCALL_DEFINE5(mremap, unsigned long, addr, unsigned long, old_len,
 				}
 			}
 
+			if (vma->vm_flags & VM_LOCKED) {
+				if (__account_locked_vm(mm, pages, current,
+						capable(CAP_IPC_LOCK))) {
+					if (vma->vm_flags & VM_ACCOUNT)
+						vm_unacct_memory(pages);
+					ret = -ENOMEM;
+					goto out;
+				}
+			}
+
 			/*
 			 * Function vma_merge() is called on the extension we are adding to
 			 * the already existing vma, vma_merge() will merge this extension with
@@ -1038,14 +1062,16 @@ SYSCALL_DEFINE5(mremap, unsigned long, addr, unsigned long, old_len,
 					extension_pgoff, vma_policy(vma),
 					vma->vm_userfaultfd_ctx, anon_vma_name(vma));
 			if (!vma) {
+				// TODO: We always unacct memory
+				// regardless of VM_ACCOUNT flags?
 				vm_unacct_memory(pages);
+				__unaccount_locked_vm(mm, pages);
 				ret = -ENOMEM;
 				goto out;
 			}
 
 			vm_stat_account(mm, vma->vm_flags, pages);
 			if (vma->vm_flags & VM_LOCKED) {
-				mm->locked_vm += pages;
 				locked = true;
 				new_addr = addr;
 			}
diff --git a/mm/secretmem.c b/mm/secretmem.c
index 04c3ac9..4515eb4 100644
--- a/mm/secretmem.c
+++ b/mm/secretmem.c
@@ -120,13 +120,11 @@ static int secretmem_release(struct inode *inode, struct file *file)
 
 static int secretmem_mmap(struct file *file, struct vm_area_struct *vma)
 {
-	unsigned long len = vma->vm_end - vma->vm_start;
-
 	if ((vma->vm_flags & (VM_SHARED | VM_MAYSHARE)) == 0)
 		return -EINVAL;
 
-	if (mlock_future_check(vma->vm_mm, vma->vm_flags | VM_LOCKED, len))
-		return -EAGAIN;
+	if (account_locked_vm(vma->vm_mm, vma->vm_end - vma->vm_start))
+		return -ENOMEM;
 
 	vma->vm_flags |= VM_LOCKED | VM_DONTDUMP;
 	vma->vm_ops = &secretmem_vm_ops;
-- 
git-series 0.9.1
