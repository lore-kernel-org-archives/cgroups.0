From: Hillf Danton <dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH -V8 02/16] hugetlb: don't use ERR_PTR with VM_FAULT* values
Date: Sun, 10 Jun 2012 09:59:28 +0800
Message-ID: <CAJd=RBCRTj0BVdngyb7eHXCwB7pCp_tS6LNqmg1Uc-v_GbT4SQ@mail.gmail.com>
References: <1339232401-14392-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	<1339232401-14392-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=qvUkzTIe+C/ofKOsT5LRBU8IePiF+9lP4290zYqsIJo=;
        b=wa9iwDr+ErOCZb26Tdu974aY3G2YiYzs2rk6RDm+7L3URP4LdQMYYXbTx1G0gveJ7l
         bpmbynxpRqyg7gppqLRRmjgTrlKxZY4sRC3sodRaZsVStLCHE165TA+okC8YbrAg7wyX
         CGkwD/6VNPT30t1oiSX0VuMSN6wG5Q5UCVax47n1O03oMfg6aTbeYVq0/mgqMGpcO2Uf
         1U3r8axcp3TKPoLsC+vSb9NzNodM1tuT7qx+OKFTJEnqOBu3lG61eYM2dr0YnSJsLrpl
         GOkCC0HB6MtIHZi5S7ON8WofKDSxJD4N+CwHjuJBD5OahneRv//HGoieV8eELY5pkum8
         Tfrw==
In-Reply-To: <1339232401-14392-3-git-send-email-aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sat, Jun 9, 2012 at 4:59 PM, Aneesh Kumar K.V
<aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org> wrote:
> From: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
>
> The current use of VM_FAULT_* codes with ERR_PTR requires us to ensure
> VM_FAULT_* values will not exceed MAX_ERRNO value. Decouple the
> VM_FAULT_* values from MAX_ERRNO.
>
> Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> ---

Thank you, AKKV.

Acked-by: Hillf Danton <dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
