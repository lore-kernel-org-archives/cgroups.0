From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v9 3/4] cgroups: allow a cgroup subsystem to reject a fork
Date: Fri, 17 Apr 2015 16:55:45 -0400
Message-ID: <20150417205545.GJ16743@htj.duckdns.org>
References: <1428799917-15141-1-git-send-email-cyphar@cyphar.com>
 <1428799917-15141-4-git-send-email-cyphar@cyphar.com>
 <20150413142439.GA2596@htj.duckdns.org>
 <CAOviyajqc_ip2Lpa5NTLLXxQ7JghYXg1UL3vXDdpbbnhmsfXEQ@mail.gmail.com>
 <20150414121732.GL2596@htj.duckdns.org>
 <CAOviyaj6eQ6s50+DrQN8yFAp7q5Y6b4ReFOT8XT0UufPb5J0xQ@mail.gmail.com>
 <20150417144519.GC1954@htj.duckdns.org>
 <CAOviyagcvtpDL1OONXR_-fX6X6N+-KfDw5mmpn=iQU+ZNps02g@mail.gmail.com>
 <20150417204206.GI16743@htj.duckdns.org>
 <CAOviyah2dBbc5MecxzCfOt36dVfCaN7F7u+5ycPmp3eVDc_J2Q@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=Wzxla2PtyUT8WUfOf2h59J0JQKtkl0L6OXceOKPt7K8=;
        b=f2jxvJ4Mlrgy1Gf7x/Iy2h89vNladciT6Gygi9X2vWE7N38E91PvvV7Cm7cE21gLGb
         /NTQA6AFnx4vPt33WV6Y86+bUMckzIv30u4zyaeheBOEAQv1Ntz0CHQLByWXThuqTGg7
         6Pho0e9U6PsC5z5yGdke2mVPgWwTtw1ocSEMLuFpcA+CRFgMJWmjNHR8d8uw7Ym9bLcN
         Y4YP0EFaCDNdaBhUHzJ9vpmvj+2yzmIVRm8qX3b6zZq0Lz44YW0ypbF6oJZw0TgRTka7
         TrZcf5rdHeP2VPhhvb/OOJFkKCU9y2pBdZZ3KFdDILpwscvbAqWuJRX9LThfOQcjaM1u
         QBSA==
Content-Disposition: inline
In-Reply-To: <CAOviyah2dBbc5MecxzCfOt36dVfCaN7F7u+5ycPmp3eVDc_J2Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, richard-/L3Ra7n9ekc@public.gmane.org, =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sat, Apr 18, 2015 at 06:48:55AM +1000, Aleksa Sarai wrote:
> Do you mean like this?
> 
> #define SUBSYS_TAG_COUNT(_tag) (CGROUP_ ## _tag ## _END - CGROUP_ ##
> _tag ## _START)
> 
> That's fine I guess, I just wanted to match CGROUP_SUBSYS_COUNT in
> semantics, but I'll do that if you prefer it that way.

Not even that, just do it manually.

#define CGROUP_TAGNAME_COUNT	(CGROUP_TAGNAME_END - CGROUP_TAGNAME_START)

At maximum, we're only gonna have a few of these.  No reason to be
smart about it.

-- 
tejun
