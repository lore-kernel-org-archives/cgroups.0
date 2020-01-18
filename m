From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [Patch v4] mm: thp: remove the defer list related code since
 this will not happen
Date: Sat, 18 Jan 2020 14:54:21 -0800
Message-ID: <20200118145421.0ab96d5d9bea21a3339d52fe@linux-foundation.org>
References: <20200117233836.3434-1-richardw.yang@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579388062;
        bh=Sev9wYvUYEKc/zi96JR7EJPQmQ+w++cAUQuho0Lvcrw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bx8VFTpKrukNtyrKYNpWQTv9MPPdUb67f7YOlBo4dKRK+/i/MOj7Eaf0YavBqSzEe
         /mdWpMo8vERRzmRc3gO8wNVjeuTCRnI5FxQ2nWx6Sot5YFhcS6n69JBLu0rE7IKoF0
         p+s5lIVAktqhjyYPmz4/WQHgBENTGQrwmRzX093g=
In-Reply-To: <20200117233836.3434-1-richardw.yang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Wei Yang <richardw.yang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, ktkhai-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org, kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sat, 18 Jan 2020 07:38:36 +0800 Wei Yang <richardw.yang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote:

> If compound is true, this means it is a PMD mapped THP. Which implies
> the page is not linked to any defer list. So the first code chunk will
> not be executed.
> 
> Also with this reason, it would not be proper to add this page to a
> defer list. So the second code chunk is not correct.
> 
> Based on this, we should remove the defer list related code.
> 
> Fixes: 87eaceb3faa5 ("mm: thp: make deferred split shrinker memcg aware")
> 
> Signed-off-by: Wei Yang <richardw.yang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> Suggested-by: Kirill A. Shutemov <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>    [5.4+]

This patch is identical to "mm: thp: grab the lock before manipulating
defer list", which is rather confusing.  Please let people know when
this sort of thing is done.

The earlier changelog mentioned a possible race condition.  This
changelog does not.  In fact this changelog fails to provide any
description of any userspace-visible runtime effects of the bug. 
Please send along such a description for inclusion, as always.

