From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Why does devices cgroup check for CAP_SYS_ADMIN explicitly?
Date: Tue, 6 Nov 2012 10:08:33 -0800
Message-ID: <20121106180833.GN30069@mtj.dyndns.org>
References: <20121106150131.GA14640@sergelap>
 <20121106150639.GB30069@mtj.dyndns.org>
 <871ug6rbio.fsf@xmission.com>
 <20121106154320.GE30069@mtj.dyndns.org>
 <87sj8mogpp.fsf@xmission.com>
 <20121106165246.GF30069@mtj.dyndns.org>
 <20121106173104.GA27990@sergelap>
 <20121106173823.GK30069@mtj.dyndns.org>
 <20121106174130.GL30069@mtj.dyndns.org>
 <20121106180233.GA31008@sergelap>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=qIXkFHl1iW/pYARHSFqWpwk7iY3XTmeCGCNBr5JInPg=;
        b=jUnd3ucBA1GGhmPDQpgryYzmoNDIt6N9HN4Q2k3ulGpC3V8VZA1c5caTUzSPm0fDd3
         If/ZEX7gcdq5mGCojX6fNGSdYjSq6p4t4GNlbmiefMwcvpBURWCqJBdRvTXJysWiEbqV
         sP0wjW1Y792JBhGlX5CmcJ801uU+Is5Mc/J+BtnfJgMxiQfjx4YIpQ7Z4WwT0pZj1hPQ
         X9Lp2Ml5v3kqijp4xHUSAWFjeammuDv3LR+BLrmEjd7bu/S67N/rQl7WB746ND1GIDtm
         JTREq7ySq5+uebZUd29UzC3aFYj8xCNyj+kCmB8nF5cai+6MDt1F8VFB03A9BtYWhe08
         kXDQ==
Content-Disposition: inline
In-Reply-To: <20121106180233.GA31008@sergelap>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org

Hello, Serge.

On Tue, Nov 06, 2012 at 12:02:33PM -0600, Serge Hallyn wrote:
> So to be clear, if I want a user to be able to confine his own
> compute-intensive tasks and freeze them, the recommended route will be
> with privileged (setuid-root) helpers?

Something like that.  I think we'll eventually need a policy manager
in userland which controls the whole hierarchy.  Not sure how that
will look at this point tho, but cgroupfs will be an interface to just
expose cgroup configuration directly rather than allow multiplexing
userland / namespace / whatnot multiplexing on top of it.

Thanks.

-- 
tejun
