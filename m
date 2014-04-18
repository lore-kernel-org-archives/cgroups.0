From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 12/12] cgroup: implement dynamic subtree controller
 enable/disable on the default hierarchy
Date: Fri, 18 Apr 2014 16:41:08 -0400
Message-ID: <20140418204108.GL23576@htj.dyndns.org>
References: <1397511430-2673-1-git-send-email-tj@kernel.org>
 <1397511430-2673-13-git-send-email-tj@kernel.org>
 <CAC4Lta0tD=FbtVpGnLw2sKMY69+AnqYqaOvCQdFs88JeR5Pemw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=iGKiZW00O9qbS5iYdgHyziTmihOPJjNAqWkqJPgCbJA=;
        b=GzQTVopfNX73RROzQBODlaWrpG3r0YmQRHKW+E+rfI9J5n63l3z/BEjq+b/KInZn8o
         ubyjtmfN/I7hS6mR7Ko4+MZWTF0bRxX2J6omLWVcPnmYCNMiueFm++dAiMTcWfFTf0oD
         G4fpLj7ZW3D3QUGXBxuixL8twn2moy9nBsLSAvvJ3xdAuPJfYb2+uUvJzqKLCXbKoWUr
         nZtheZ92ddJUB1vYNhwZ5d0ybEiv+N2waCnysJI+xyiV1kyGQkjtQHqLzLQtEL9BNr6L
         cenZtoKe9PeelL4RCro2QHLhOwbC4MimpriLIIML8v65hUSXPdRBJDgT6yH49NdQL63W
         JsQg==
Content-Disposition: inline
In-Reply-To: <CAC4Lta0tD=FbtVpGnLw2sKMY69+AnqYqaOvCQdFs88JeR5Pemw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Raghavendra KT <raghavendra.kt-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello,

On Thu, Apr 17, 2014 at 11:33:50PM +0530, Raghavendra KT wrote:
> On Tue, Apr 15, 2014 at 3:07 AM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> I undertsand that with the above parsing we could do
> echo "-blkio +blkio" > cgroup.subtree_control and honor last enable/disable.

Yeah, and the behavior is described in the following document.

 http://lkml.kernel.org/g/20140416145248.GD1257-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org

> It confused me while testing. do you think we should return -EINVAL in
> such case?

Hmmm... I think whatever comes later wins is a pretty clear and easy
rule, no?

-- 
tejun
