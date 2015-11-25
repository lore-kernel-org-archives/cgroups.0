From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Subject: Re: [PATCH 1/2] memcg: flatten task_struct->memcg_oom
Date: Wed, 25 Nov 2015 18:31:41 +0300
Message-ID: <CAPAsAGwa9-7UBUnhysfek3kyWKMgaUJRwtDPEqas1rKwkeTtoA@mail.gmail.com>
References: <20150913185940.GA25369@htj.duckdns.org>
	<55FEC685.5010404@oracle.com>
	<20150921200141.GH13263@mtj.duckdns.org>
	<20151125144354.GB17308@twins.programming.kicks-ass.net>
	<20151125150207.GM11639@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=W8eRCEoLNywJsKEESpAVa/KrkmanmU7uQQ/CGS6ORC4=;
        b=t2l1T3dogoE5ndg9kdyj1odFtMAkXLjVgb1CMlKp2QPbcUdnutLiyQbSdjJ0vCl7Sn
         GALB5soUnOGtHejE9PYrD7NkB35aqvbgz8YbFd1R2YOogbfKMGw84kNIHZzs7IQ5NoSv
         byAOGl6VBew1hygRsT3oAS2bP/xncvHCOmEBl3yGGEzWOOTeF1au11Z85CO4N9rQsPPX
         YtPafOFf3tQ8uGePbgzAdeXQo/xb3CcUN/imx33BriwQxcAcCZpUIGuRMm2eycvm0wnB
         gRcO/amrpWssVBNnNeLZ8T6W422sXcC4M+3S80Lmubx0k6AbzaqgpU6y9IsdQpFa9qhi
         rmjw==
In-Reply-To: <20151125150207.GM11639@twins.programming.kicks-ass.net>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@redhat.com>, Sasha Levin <sasha.levin@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, mhocko@kernel.org, cgroups@vger.kernel.org, "linux-mm@kvack.org" <linux-mm@kvack.org>, vdavydov@parallels.com, kernel-team@fb.com, Dmitry Vyukov <dvyukov@google.com>

2015-11-25 18:02 GMT+03:00 Peter Zijlstra <peterz@infradead.org>:
> On Wed, Nov 25, 2015 at 03:43:54PM +0100, Peter Zijlstra wrote:
>> On Mon, Sep 21, 2015 at 04:01:41PM -0400, Tejun Heo wrote:
>> > So, the only way the patch could have caused the above is if someone
>> > who isn't the task itself is writing to the bitfields while the task
>> > is running.  Looking through the fields, ->sched_reset_on_fork seems a
>> > bit suspicious.  __sched_setscheduler() looks like it can modify the
>> > bit while the target task is running.  Peter, am I misreading the
>> > code?
>>
>> Nope, that's quite possible. Looks like we need to break up those
>> bitfields a bit. All the scheduler ones should be serialized by
>> scheduler locks, but the others are fair game.
>
> Maybe something like so; but my brain is a complete mess today.
>
> ---
>  include/linux/sched.h | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
>
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index f425aac63317..b474e0f05327 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1455,14 +1455,15 @@ struct task_struct {
>         /* Used for emulating ABI behavior of previous Linux versions */
>         unsigned int personality;
>
> -       unsigned in_execve:1;   /* Tell the LSMs that the process is doing an
> -                                * execve */
> -       unsigned in_iowait:1;
> -
> -       /* Revert to default priority/policy when forking */
> +       /* scheduler bits, serialized by scheduler locks */
>         unsigned sched_reset_on_fork:1;
>         unsigned sched_contributes_to_load:1;
>         unsigned sched_migrated:1;
> +       unsigned __padding_sched:29;

AFAIK the order of bit fields is implementation defined, so GCC could
sort all these bits as it wants.
You could use unnamed zero-widht bit-field to force padding:

         unsigned :0; //force aligment to the next boundary.

> +
> +       /* unserialized, strictly 'current' */
> +       unsigned in_execve:1; /* bit to tell LSMs we're in execve */
> +       unsigned in_iowait:1;
>  #ifdef CONFIG_MEMCG
>         unsigned memcg_may_oom:1;
>  #endif
>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
