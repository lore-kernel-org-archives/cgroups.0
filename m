From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 13/15] kernel: convert numa_group.refcount from atomic_t
 to refcount_t
Date: Fri, 7 Jul 2017 11:29:42 +0200
Message-ID: <20170707092942.r2juhqprjo4petib@hirez.programming.kicks-ass.net>
References: <1499418269-3686-1-git-send-email-elena.reshetova@intel.com>
 <1499418269-3686-14-git-send-email-elena.reshetova@intel.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=dz6IaWwM7xuDOuEaa266gug4XJprEOlhapyOhdkN4lc=; b=oF7uWWqVNAME0xaBKySHjLY/v
        UeLvry8ti66x0L2JU6d2d/3Kqz1COQw9+RhdxRXqbM/gu1ftP+RNOIGd5IlQcWpRldrmsSV/suj4y
        UDGTbaFrNWjd2YL8xV6WrtvITESz9plWh/zFZ7AHxHzaLRC51sTBBYWFZn/lzp7JCcIOI6M6pswLs
        HyHJdfDXziwNb3iz98refvsFudNa70MNEjCUU3FGaZeZKJd8+g/QzfwkeBy2P/5eP7fdoBaW04xZi
        B7y5HWWVzx2MVuS0bDMplMewNEg0otdGcHqRcJMTA6EMXD6RnvjShCl/65jVL9BPldKsz6mKsRCPj
      
Content-Disposition: inline
In-Reply-To: <1499418269-3686-14-git-send-email-elena.reshetova@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Elena Reshetova <elena.reshetova@intel.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-audit@redhat.com, linux-fsdevel@vger.kernel.org, gregkh@linuxfoundation.org, viro@zeniv.linux.org.uk, tj@kernel.org, mingo@redhat.com, hannes@cmpxchg.org, lizefan@huawei.com, acme@kernel.org, alexander.shishkin@linux.intel.com, eparis@redhat.com, akpm@linux-foundation.org, arnd@arndb.de, luto@kernel.org, keescook@chromium.org, Hans Liljestrand <ishkamiel@gmail.com>, David Windsor <dwindsor@gmail.com>

On Fri, Jul 07, 2017 at 12:04:27PM +0300, Elena Reshetova wrote:
> refcount_t type and corresponding API should be
> used instead of atomic_t when the variable is used as
> a reference counter. This allows to avoid accidental
> refcounter overflows that might lead to use-after-free
> situations.
> 
> Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
> Signed-off-by: Hans Liljestrand <ishkamiel@gmail.com>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Signed-off-by: David Windsor <dwindsor@gmail.com>

Invalid SoB..

> Subject: [PATCH 13/15] kernel: convert numa_group.refcount from atomic_t to refcount_t

> ---
>  kernel/sched/fair.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)

Invalid Subject prefix too, scheduler patches get to have "sched:"
