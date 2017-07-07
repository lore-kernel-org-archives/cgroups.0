From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 14/15] kernel: convert futex_pi_state.refcount from
 atomic_t to refcount_t
Date: Fri, 7 Jul 2017 11:26:03 +0200
Message-ID: <20170707092603.rmt4ne4c75k5qg56@hirez.programming.kicks-ass.net>
References: <1499418269-3686-1-git-send-email-elena.reshetova@intel.com>
 <1499418269-3686-15-git-send-email-elena.reshetova@intel.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=HMOtWvJnRz+LVVyF27oepqPyIX8SWyCXYRBC2H/uwBg=; b=JxIPWd37wuJnlchVv7+/6cFlt
        jd9jLUv8eOcey9LuqN66Ur5PPcDtPMJmzSdn2T59JWcgYIhDesD+MdnwCQ0KHg2F38abASqM8Q9dh
        mp58PHjhCyLETTbfCf7WGwQ7K8ZMr5jSYb6/hG9t2HtFGI+8HBjwRBdcsJDCRgetFBEewJ9W4JDuw
        OUqx7WFreu1ikrHBGuZgBCDlXFCysPlOPXX2zhPQF9N3fuv064n5TOX/PIOfGbqKXPqM11IBSjK2J
        ItamlTDEc8CyIiotL8f9TUfpUnlZGQOObg1Ev/gP+lgXFROgMZyX4YczU+piQ8/++zk0ArbYpXid3
    
Content-Disposition: inline
In-Reply-To: <1499418269-3686-15-git-send-email-elena.reshetova@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Elena Reshetova <elena.reshetova@intel.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-audit@redhat.com, linux-fsdevel@vger.kernel.org, gregkh@linuxfoundation.org, viro@zeniv.linux.org.uk, tj@kernel.org, mingo@redhat.com, hannes@cmpxchg.org, lizefan@huawei.com, acme@kernel.org, alexander.shishkin@linux.intel.com, eparis@redhat.com, akpm@linux-foundation.org, arnd@arndb.de, luto@kernel.org, keescook@chromium.org, Hans Liljestrand <ishkamiel@gmail.com>, David Windsor <dwindsor@gmail.com>, Thomas Gleixner <tglx@linutronix.de>

On Fri, Jul 07, 2017 at 12:04:28PM +0300, Elena Reshetova wrote:
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

I'll let tglx comment on the SoB chain, I know he likes those :-) You
did Cc him right, seeing how he's the maintainer of this stuff..

*sigh* you didn't :-( After so many patches send you _really_ should
know to Cc the right people.

> ---
>  kernel/futex.c | 13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)

> @@ -814,7 +815,7 @@ static struct futex_pi_state *alloc_pi_state(void)
>  
>  static void get_pi_state(struct futex_pi_state *pi_state)
>  {
> -	WARN_ON_ONCE(!atomic_inc_not_zero(&pi_state->refcount));
> +	WARN_ON_ONCE(!refcount_inc_not_zero(&pi_state->refcount));
>  }

I think we have refcount_inc() for just that case, no?


