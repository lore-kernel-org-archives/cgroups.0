From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v6 0/7] freezer for cgroup v2
Date: Thu, 24 Jan 2019 07:26:23 -0800
Message-ID: <20190124152623.GH50184@devbig004.ftw2.facebook.com>
References: <20181222000307.28231-1-guro@fb.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=0FVwBJEbGSCpbztzTtTWXO0usmZDa4dlEKlgDqHqCvA=;
        b=B8AqbH/hEr7vFeOCysJs7BMVx3i84OMajQGOlflkd98UzHDo0h0ijKJXNfYwVy/+rX
         Sk+Vt6Dr5Y34f+gGZc/qAst6tHczDauakCVy22pKxBWFPjnRi98SE+HtVUrHJd55h52K
         0MYyAKhMTfDpiE0TA8a+yMIS9z5W3XZvjehss3rxSDOa7bcsV/4+OEbzUtbRbGcVECRS
         KkbsuU7HI4rfxZHi6XMwtb7ZSiBJxYmU8OavhKWqCZrasgWtKk2+Jn3WXKUMV+De1AF/
         5MaGD7gCkbvlm0ZeGhPqUZRSewl4Zxu8Ot0PweRe1VZYsFW4t01Vm5qkGSPvqUUrMw3Z
         ucZA==
Content-Disposition: inline
In-Reply-To: <20181222000307.28231-1-guro@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guroan@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Roman Gushchin <guro@fb.com>

On Fri, Dec 21, 2018 at 04:03:00PM -0800, Roman Gushchin wrote:
> This patchset implements freezer for cgroup v2.
> 
> It provides similar functionality as v1 freezer, but the interface
> conforms to the cgroup v2 interface design principles, and it
> provides a better user experience: tasks can be killed, ptrace works,
> there is no separate controller, which has to be enabled, etc.
> 
> Patches (1), (2) and (3) are some preparational work, patch (4) contains
> the implementation, patch (5) is a small cgroup kselftest fix,
> patch (6) covers freezer adds 6 new kselftests to cover the freezer
> functionality. Patch (7) adds corresponding docs.
> 
> v6->v5:
>   - reverted to clear TIF_SIGPENDING with additional checks before schedule(),
>   as proposed by Oleg Nesterov
>   - made cgroup v2 freezer working with the system freezer (by using
>   freezable_schedule())
>   - make freezer working with SIGSTOPped and PTRACEd tasks
>   - added tests to cover freezing a cgroup with SIGSTOPped and PTRACEd tasks

Oleg, ping?

Thanks.

-- 
tejun
