From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC 02/18] cgroup_pids: track maximum pids
Date: Mon, 13 Jun 2016 17:33:54 -0400
Message-ID: <20160613213354.GH31708@htj.duckdns.org>
References: <1465847065-3577-1-git-send-email-toiwoton@gmail.com>
 <1465847065-3577-3-git-send-email-toiwoton@gmail.com>
 <20160613211227.GG31708@htj.duckdns.org>
 <17cb1a37-47b1-dbd4-6835-efad3cf6c12f@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=w6N0oppfYPcmdAfnun/1Nu5UgHiZHbD8bc/GRrbdXr4=;
        b=A/Ak7M2kua+HZOy4bH6yakmY4vU9PNtkmANe8PJE+9xKxTK4HeIm1qJZ5Jt6QWvuTL
         33kVsajJgxn1IyznjJ53mBrT2dRFtOvLiGZbH+fJG1JADK0g38OPlmFFyXbFum9iW6lL
         djO9SZI0IKxRZtwJZ6BIA+L7DKBT0pN4RNICHzbQqVmDSLcpbDnhflv7PNelp4+dZ9jR
         GPadet5I71fQzfV+HVXF9KKLWnzJJF/83+hvx9j62I6r8Cf+uoZEn92/8IDcunHq/qC5
         +ZtkZ+7lVLNSQRYqMdMytHHrWiY9H4fAvauy1RJalbbiko21Yhk/IqYgCi6kMY3vfylM
         TR+g==
Content-Disposition: inline
In-Reply-To: <17cb1a37-47b1-dbd4-6835-efad3cf6c12f-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Topi Miettinen <toiwoton-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello,

On Mon, Jun 13, 2016 at 09:29:32PM +0000, Topi Miettinen wrote:
> I used fork callback as I don't want to lower the watermark in all cases
> where the charge can be lowered, so I'd update the watermark only when
> the fork really happens.

I don't think that would make a noticeable difference.  That's where
we decide whether to grant fork or not after all and thus where the
actual usage is.

> Is there a better way to compare and set? I don't think atomic_cmpxchg()
> does what's needed,

cmpxchg loop should do what's necessary although I'm not sure how much
being strictly correct matters here.

Thanks.

-- 
tejun
