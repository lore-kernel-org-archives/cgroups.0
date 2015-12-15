From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/6] cgroup: Fix line length to 80 characters
Date: Tue, 15 Dec 2015 12:11:10 -0500
Message-ID: <20151215171110.GE4026@mtj.duckdns.org>
References: <1450182045-27480-1-git-send-email-kuba.kunert@gmail.com>
 <1450182045-27480-2-git-send-email-kuba.kunert@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=DNMj/SoXOv6qCMYbg5RubwiI8/ZnhDT9//zs94xzVzs=;
        b=iB4o7iNXj2fxtWQxUMTmPhY6U88pZZkd83ebRszxHPG7ZqO/yYbKxUpYFXXrm+j4DM
         w0/65m3PRjXk9Wg3kVuiZcG+SFThig8vAVU310AluPpTVAYKOucN00miNzkGOVDgglt5
         Q3fJk0W9JBMbZ4ErBbt27ydgdTWoDVL9ID6DT73CmyvPOSWCOGDRz5UAl+Wmes7canEl
         73tn4VgJf1dtHcHOJO/nsX1dVZs8rzFFo+ZTieAAceFqwAJGY428kLApSeArL2vg0p6y
         3vywAiyMZAqid85Z/EW8VpeEIPcTLZkrgm72n96gSirD3TSfCUd0CnpXzfGKSAFjIKmN
         sQUQ==
Content-Disposition: inline
In-Reply-To: <1450182045-27480-2-git-send-email-kuba.kunert-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jakub Kunert <kuba.kunert-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Dec 15, 2015 at 01:20:41PM +0100, Jakub Kunert wrote:
> Fix checkpatch.pl warnings with lines over 80 characters.

Again, checkpatch.pl isn't ten commandments.  I'm gonna skip the rest
of the patchset.  If you think there are salvegeable changes in this
series, please actually think about them and resend separately.

-- 
tejun
