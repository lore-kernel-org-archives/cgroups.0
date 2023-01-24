From: Alistair Popple <apopple@nvidia.com>
Subject: [RFC PATCH 12/19] kvm/book3s_64_vio: Convert account_locked_vm() to vm_account_pinned()
Date: Tue, 24 Jan 2023 16:42:41 +1100
Message-ID: <3ef4b18a0ff174fcb2c81f8fafe900b43216d473.1674538665.git-series.apopple@nvidia.com>
References: <cover.f52b9eb2792bccb8a9ecd6bc95055705cfe2ae03.1674538665.git-series.apopple@nvidia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane-mx.org@lists.ozlabs.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OiXAsGxFz4TnMqFpYvIEfO7AjQpGiup8ce6UITBOatk=;
 b=rgnlu9rLsxAYDcNmduxLEEeqHjkqyJS3VwgYTl7/AIDwfxlMSrj0wUWbB1hiNextRggFqomxQobZDTBP2aMhutu2VibNwARNt+b9Q7eMFhFJNMF9x+umjhMmRbG0FWe3HZ/YsLqRo2dBeFb7A3nzM9TE9FhPlqZ3CSRVYLdkksCs7Ty7EtoaZj2xPj6VvEE4/aJOTT9ibTj++8gnvdY+Sdyq/N0iN+4VhT5kxl3iAoydB+HNzwr0qDA5wQY6ZSys/hCtULqLO53ik4/AMCK03iWoGPL6Uqe/9aDpLpycnuwThsGaBx1cuZljMspBJmO5B/rHUR0Qr8sCNB1gSmTpVw==
In-Reply-To: <cover.f52b9eb2792bccb8a9ecd6bc95055705cfe2ae03.1674538665.git-series.apopple@nvidia.com>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane-mx.org@lists.ozlabs.org
Sender: "Linuxppc-dev" <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane-mx.org@lists.ozlabs.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-mm@kvack.org, cgroups@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org, daniel@ffwll.ch, kvm@vger.kernel.org, Alexey Kardashevskiy <aik@ozlabs.ru>, jhubbard@nvidia.com, Alistair Popple <apopple@nvidia.com>, linux-kernel@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>, mkoutny@suse.com, jgg@nvidia.com, hannes@cmpxchg.org, Paolo Bonzini <pbonzini@redhat.com>, surenb@google.com, tjmercier@google.com

book3s_64_vio currently accounts for pinned pages with
account_locked_vm() which charges the pages to mm->locked_vm. To make
this consistent with other drivers switch to using
vm_account_pinned().

Signed-off-by: Alistair Popple <apopple@nvidia.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>
Cc: linuxppc-dev@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
---
 arch/powerpc/kvm/book3s_64_vio.c | 10 +++++-----
 include/linux/kvm_host.h         |  1 +
 virt/kvm/kvm_main.c              |  3 +++
 3 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_64_vio.c b/arch/powerpc/kvm/book3s_64_vio.c
index 95e738e..ecd1deb 100644
--- a/arch/powerpc/kvm/book3s_64_vio.c
+++ b/arch/powerpc/kvm/book3s_64_vio.c
@@ -273,8 +273,8 @@ static int kvm_spapr_tce_release(struct inode *inode, struct file *filp)
 		}
 	}
 
-	account_locked_vm(kvm->mm,
-		kvmppc_stt_pages(kvmppc_tce_pages(stt->size)), false);
+	vm_unaccount_pinned(&kvm->vm_account,
+		kvmppc_stt_pages(kvmppc_tce_pages(stt->size)));
 
 	kvm_put_kvm(stt->kvm);
 
@@ -301,8 +301,8 @@ long kvm_vm_ioctl_create_spapr_tce(struct kvm *kvm,
 		(args->offset + args->size > (ULLONG_MAX >> args->page_shift)))
 		return -EINVAL;
 
-	npages = kvmppc_tce_pages(args->size);
-	ret = account_locked_vm(mm, kvmppc_stt_pages(npages), true);
+	npages = kvmppc_tce_pages(size);
+	ret = vm_account_pinned(&kvm->vm_account, kvmppc_stt_pages(npages));
 	if (ret)
 		return ret;
 
@@ -347,7 +347,7 @@ long kvm_vm_ioctl_create_spapr_tce(struct kvm *kvm,
 
 	kfree(stt);
  fail_acct:
-	account_locked_vm(mm, kvmppc_stt_pages(npages), false);
+	vm_unaccount_pinned(&kvm->vm_account, kvmppc_stt_pages(npages));
 	return ret;
 }
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 4f26b24..25ed390 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -717,6 +717,7 @@ struct kvm {
 	 */
 	struct mutex slots_arch_lock;
 	struct mm_struct *mm; /* userspace tied to this vm */
+	struct vm_account vm_account;
 	unsigned long nr_memslot_pages;
 	/* The two memslot sets - active and inactive (per address space) */
 	struct kvm_memslots __memslots[KVM_ADDRESS_SPACE_NUM][2];
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 9c60384..770d037 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1142,6 +1142,7 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
 	KVM_MMU_LOCK_INIT(kvm);
 	mmgrab(current->mm);
 	kvm->mm = current->mm;
+	vm_account_init_current(&kvm->vm_account);
 	kvm_eventfd_init(kvm);
 	mutex_init(&kvm->lock);
 	mutex_init(&kvm->irq_lock);
@@ -1258,6 +1259,7 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
 out_err_no_srcu:
 	kvm_arch_free_vm(kvm);
 	mmdrop(current->mm);
+	vm_account_release(&kvm->vm_account);
 	module_put(kvm_chardev_ops.owner);
 	return ERR_PTR(r);
 }
@@ -1327,6 +1329,7 @@ static void kvm_destroy_vm(struct kvm *kvm)
 	preempt_notifier_dec();
 	hardware_disable_all();
 	mmdrop(mm);
+	vm_account_release(&kvm->vm_account);
 	module_put(kvm_chardev_ops.owner);
 }
 
-- 
git-series 0.9.1
