From: Hiroyuki Kamezawa <kamezawa.hiroyuki-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC][PATCH 0/7 v2] memcg: prevent failure in pre_destroy()
Date: Sat, 28 Apr 2012 08:48:18 +0900
Message-ID: <CABEgKgrir3PBGqm_9FmYsZTiFqsZ=Cdt5iZDu5WcOHPtZuEbFg@mail.gmail.com>
References: <4F9A327A.6050409@jp.fujitsu.com>
	<20120427181642.GG26595@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=cZM5V9G2aFKWUgkd12C/7mhYz/Q+8ya4NVHiU0iGA+s=;
        b=L/1qLWv7uUcDbj9TU3Qp5sLLPq6syGzv8ssmfSSX5ZQmuuS1p0VdZxdQNjRNwVusWD
         4Lydhme8eSEb/HA0SuzcStsPsfpa/CWjqdMI+q+1AkRNi3vusuMbOnjM0dF2JbAfYUzp
         xL/OFdZFhD5Nw6j8+HA5UL1AHlhQntK2m5NwdwSvHk5pnrWzj/q51geGQxwme3pO3Tme
         7IwEXakaY1KmQrdh8eXMuNh3ud/8f//Ig1D8JayLqYjY7IsS8YpEBBuqXRZXPoLKB/Ev
         tYOh9Wf8UCk+OY6mBq8Wq8tUwGuCpmbpWMt4+Q8HZ9TaL2sRW2h+5Tve0vIw79D64PQb
         7ibw==
In-Reply-To: <20120427181642.GG26595-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Han Ying <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On Sat, Apr 28, 2012 at 3:16 AM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> Hello,
>
> On Fri, Apr 27, 2012 at 02:45:30PM +0900, KAMEZAWA Hiroyuki wrote:
>> This is a v2 patch for preventing failure in memcg->pre_destroy().
>> With this patch, ->pre_destroy() will never return error code and
>> users will not see warning at rmdir(). And this work will simplify
>> memcg->pre_destroy(), largely.
>>
>> This patch is based on linux-next + hugetlb memory control patches.
>
> Ergh... can you please set up a git branch somewhere for review
> purposes?
>
I'm sorry...I can't. (To do that, I need to pass many my company's check.)
I'll repost all a week later, hugetlb tree will be seen in memcg-devel or
linux-next.

Thanks,
-Kame
