From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Cgroups v2 thread mode "domain invalid" state
Date: Thu, 21 Dec 2017 16:15:54 -0800
Message-ID: <20171222001554.GH1084507@devbig577.frc2.facebook.com>
References: <CAKgNAkg2u=zt87tKk35vR+tQ7DnkJp9vbj+8n88=_MCcvmH9oQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ExKJpbLanxyWXOfPHDzgMcUTj1x5S9/aH0MtB6yLZA0=;
        b=W1E4EE26HcGaNdqYbqNprBa/m01vd4jH1xtTnTm9K5/Hq8fhcJ6M4dZabOsu9XXakB
         JxUl5hO8aNV7sxH+zUjd9a8wSj4u5MjHrkreCeFvAkfP7Qu3ohwR3N3Kq22cSV8R/4YA
         5/u+4mr6KbPzW7djVYtS1iWYDwsic5bGpJ2obtKHjWjEEq8fmirv8FDI3dsxTxriJytO
         PjuDYnNi4FW8MuaDCqb00vuP402PMOOUrOi75aY6OujVgCgm5bOpy8CgTQfpTI1vfZSR
         aHZIw0L8rzC8RRRgem7qR12YkcxUqztrokYy9Lmqjt8EfsjtqEPU6gjiZzWVqSdNnzFT
         8vsg==
Content-Disposition: inline
In-Reply-To: <CAKgNAkg2u=zt87tKk35vR+tQ7DnkJp9vbj+8n88=_MCcvmH9oQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello,

On Wed, Dec 20, 2017 at 09:32:04PM +0100, Michael Kerrisk (man-pages) wrote:
> I did find the July 2017 mail thread
> "[PATCH 5/6] cgroup: implement cgroup v2 thread support"
> (https://marc.info/?t=150025735500001&r=1&w=2)
> where this cgroup type was discussed, but I must admit that I still
> don't get it. Instead of converting cgroups under a threaded subtree
> to "domain invalid" type, why can't they just be turned straight into
> "threaded" type?
> 
> I guess another way of asking this question is: what possibilities
> does manually switching each "domain invalid" cgroup to "threaded"
> allow that wouldn't be allowed by immediately making all of the
> cgroups in a threaded subtree "threaded"?

IIRC, there were two reasons.  (Writing from memory, so I might not be
completely accurate.)

* Consistency w/ the cgroups right under the root cgroup.  Because
  they can be both domains and threadroots, we can't switch the
  children over to thread mode automatically.  Doing that for cgroups
  further down in the hierarchy would be really inconsistent.

* Possible extension to threadmode.  If we figure out how to do mixed
  mode further down in the hierarchy (and if there are actual use
  cases which require that), automatically switching would be really
  confusing.

The invalid state while not the most convenient is straight forward
(only the operations which are explicitly asked are performed) and
keeps the door open for future changes.

Thanks.

-- 
tejun
--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
