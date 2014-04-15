From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/3] cgroup: implement cgroup.subtree_populated for the
 default hierarchy
Date: Tue, 15 Apr 2014 10:54:50 -0400
Message-ID: <20140415145450.GL1863@htj.dyndns.org>
References: <1397511846-2904-1-git-send-email-tj@kernel.org>
 <1397511846-2904-4-git-send-email-tj@kernel.org>
 <534C83F1.9020106@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=5bJha0T7zE5mXRS+Q6tCdMHbGfPtwwIzvfzF+DMWOR4=;
        b=Itj3CI+r012OZrq9yQI0rOq/ysP6GZweVHKbFt6VF4RfpmXOoxpmcIC6EZp5TFg1HV
         6Y4YXFV66wZrSKFwMnOwgf6ahUjrK13uBFv7qJ9rhJSQFSJEIwdVcs5YZmD2Hs+CAPa3
         WWAU5tx2SsqOdHXoXjkSXjcnZeQR3Fq/4uGLoeD8aHd3dZ7GtSPqNBBeELb6nnSlr/uk
         OsFRxA8CzIdR9LawLrmYD/+zovCVrZejgZjC6KjFSCHhzQuESshO7VMGEq1VVdfDp7m1
         L1JNhwNV7UVRtmhUrul+u6DGiiYPyo4sc3r4h5q7J/hgDNhg3+wNMkimd6Hd7FjosYF6
         tl1Q==
Content-Disposition: inline
In-Reply-To: <534C83F1.9020106-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, john-jueV0HHMeujJJrXXpGQQMAC/G2K4zDHf@public.gmane.org, rlove-L7G0xEPcOZbYtjvyW6yDsg@public.gmane.org, eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org, lennart-mdGvqq1h2p+GdvJs77BJ7Q@public.gmane.org, kay-tD+1rO4QERM@public.gmane.org

Hello,

On Tue, Apr 15, 2014 at 08:57:21AM +0800, Li Zefan wrote:
> Is cgroup.tree_populated a better name?
> 
> cgroup.subtree_control controls child cgroups only, but .subtree_populated
> shows 1 if there're tasks in the cgroup or its children, so the two
> are a bit inconsistent to me.

Yes, good catch.  subtree_control affects subtree proper.
subtree_populated covers self too.  The difference is subtle and the
trade off between shared pattern in names and clarifying the subtlety
didn't seem clear-cut to me.  Hmmm....

-- 
tejun
