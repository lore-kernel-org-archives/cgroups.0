From: Tejun Heo <tj@kernel.org>
Subject: [PATCH net-next] net, cgroup: cgroup_sk_updat_lock was missing
 initializer
Date: Mon, 14 Dec 2015 11:24:06 -0500
Message-ID: <20151214162406.GA4026@mtj.duckdns.org>
References: <1449527935-27056-1-git-send-email-tj@kernel.org>
 <f90d369a0e004fee8d3bfdfe95e0abc0@HKXPR3004MB0088.064d.mgd.msft.net>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=CM4mZDX5QwZztTb2XIztcWQvj9oFHbR5rqPWWEFZO88=;
        b=B4xl9t0OjaYHNZtHQlM9NYK2D7gTTL6/W4d4nMjmJUHkWOBsEebROwqvimY4ycdzN+
         cQaDpXYYdP9Y9IV1qJlABSkDYkT+fPyRvb68aXImbeETsUlu25gXxRj6/avvWc8tAKfA
         fYU+8MPLPGAnyRbLWdqUhn5guosA8ltyTvAgrdRQmYOaCafhgO0avMRQZINtZKCsNSzG
         XvBHMz+RzMy7ltuW2ppY1fkz/xyJ9Np6mAja+BDgA0TGO6GR0bmu+ypZT22zjuyUSr/X
         v8f3M9Zgof9j/zIYvAI/0xIZ0aA9BazblMNSQlmjhXnfVycYAC0SWeXqOmruYngFkvT2
         DEPA==
Content-Disposition: inline
In-Reply-To: <f90d369a0e004fee8d3bfdfe95e0abc0@HKXPR3004MB0088.064d.mgd.msft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "davem@davemloft.net" <davem@davemloft.net>
Cc: Dexuan Cui <decui@microsoft.com>, "pablo@netfilter.org" <pablo@netfilter.org>, "kaber@trash.net" <kaber@trash.net>, "kadlec@blackhole.kfki.hu" <kadlec@blackhole.kfki.hu>, "daniel@iogearbox.net" <daniel@iogearbox.net>, "daniel.wagner@bmw-carit.de" <daniel.wagner@bmw-carit.de>, "nhorman@tuxdriver.com" <nhorman@tuxdriver.com>, "lizefan@huawei.com" <lizefan@huawei.com>, "hannes@cmpxchg.org" <hannes@cmpxchg.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>, "coreteam@netfilter.org" <coreteam@netfilter.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kernel-team@fb.com" <kernel-team@fb.com>, "ninasc@fb.com" <ninasc@fb.com>

bd1060a1d671 ("sock, cgroup: add sock->sk_cgroup") added global
spinlock cgroup_sk_update_lock but erroneously skipped initializer
leading to uninitialized spinlock warning.  Fix it by using
DEFINE_SPINLOCK().

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Dexuan Cui <decui@microsoft.com>
Fixes: bd1060a1d671 ("sock, cgroup: add sock->sk_cgroup")
---
Hello, Dexuan.

Oops, sorry about that.  Somehow thought it was a different problem
which is already fixed.  This should do it.

Thanks.

 kernel/cgroup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 4f8f792..4466273f 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -5790,7 +5790,7 @@ EXPORT_SYMBOL_GPL(cgroup_get_from_path);
 
 #if defined(CONFIG_CGROUP_NET_PRIO) || defined(CONFIG_CGROUP_NET_CLASSID)
 
-spinlock_t cgroup_sk_update_lock;
+DEFINE_SPINLOCK(cgroup_sk_update_lock);
 static bool cgroup_sk_alloc_disabled __read_mostly;
 
 void cgroup_sk_alloc_disable(void)
