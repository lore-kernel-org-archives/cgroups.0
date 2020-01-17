From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: Re: [PATCH v10 2/8] hugetlb_cgroup: add interface for charge/uncharge
 hugetlb reservations
Date: Fri, 17 Jan 2020 11:26:24 -0800
Message-ID: <7e1d2c5f-3b07-4d16-9e1b-bd89d25e7fb3@oracle.com>
References: <20200115012651.228058-1-almasrymina@google.com>
 <20200115012651.228058-2-almasrymina@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=gqxK7vkCcTECVPU7G7R4kJNNecY+690ASWDWrqyibTI=;
 b=gyhaiCtu3LD4E7u6eKLrXfbj7HV8FgjP7U5WQ1j1GRZ4ss6t53H6/PHle2lZCwM29/IC
 q5Ld+v46vPot2bGzRygxoAhYGU0mBOG4ny4lwtJIVsUkqqYSqBulidxS7cmu3rvGYqrX
 +iPv00AuJ1363TlGADLBJKEIppB1not73t7IiSOWLSMaJH4hPEc703D8IDt0dHKaiKTV
 ubuAEkU/qIDLWLzRAIKLeZeFZ36bXdc38FqNFkQPBeJCYtAted+v7P86SYQPP/EoQJWG
 RJEGpPbFdSCY6drv/8PAJuTX1JsINNRVqY6eN45zIYycfs0sSBaPbth+SO5lhg9N7rXa 3g== 
In-Reply-To: <20200115012651.228058-2-almasrymina@google.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Mina Almasry <almasrymina@google.com>, rientjes@google.com, shakeelb@google.com
Cc: shuah@kernel.org, gthelen@google.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, cgroups@vger.kernel.org, aneesh.kumar@linux.vnet.ibm.com

On 1/14/20 5:26 PM, Mina Almasry wrote:
> Augments hugetlb_cgroup_charge_cgroup to be able to charge hugetlb
> usage or hugetlb reservation counter.
> 
> Adds a new interface to uncharge a hugetlb_cgroup counter via
> hugetlb_cgroup_uncharge_counter.
> 
> Integrates the counter with hugetlb_cgroup, via hugetlb_cgroup_init,
> hugetlb_cgroup_have_usage, and hugetlb_cgroup_css_offline.
> 
> Signed-off-by: Mina Almasry <almasrymina@google.com>
> 
> ---
> 
> Changes in v10:
> - Added missing VM_BUG_ON

Thanks for addressing my comments.
I see that patch 8 was updated to address David's comments.  I will also
review patch 8 later.

I am again requesting that someone with more cgroup experience comment on
this patch.  I do not have enough experience to determine if the code to
not reparent/zombie cgroup is correct.

For now,
Acked-by: Mike Kravetz <mike.kravetz@oracle.com>
while waiting for cgroup comments.

-- 
Mike Kravetz
