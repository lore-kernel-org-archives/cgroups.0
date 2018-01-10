From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: cgroups(7): documenting /sys/kernel/cgroup files
Date: Wed, 10 Jan 2018 09:44:57 -0800
Message-ID: <20180110174457.GI3668920@devbig577.frc2.facebook.com>
References: <ff431fd8-f1c1-ed8d-2d69-64ea83a8a505@gmail.com>
 <CAKgNAkhk-527Rh6tGYJO-U3UXgwBC1+t5nB+5JEq62nTO2p15A@mail.gmail.com>
 <20180110124407.GA26913@castle.DHCP.thefacebook.com>
 <20180110140239.GX3668920@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=YrzB7b6beq8W/qY6tjlK/cLvRgG2TvZgIrT7H9BaQ/o=;
        b=DiQbLFi3cTcHe7LjnJ3zTYZi568AuWNFAKKMbFuAzTquzDxZK//hmfKelTw1U4XmIW
         siFj+O1LrshPOT2FyGM8c+fIX553uQhT+C7+iP54uFMylAJRTSBj26jrMs0LkwikDIVH
         PJXgIMlJucN0kqXz2p7y7K7xDJwMrLFvygCdGWjebvt8pjnwGMKmUnvZ6SF0E7ZytQSW
         otnVkTCEgxSSCl+xj5DQ02pgA0HqpnUqqHKlVihcRMBqtuaxo6Ev6bE4LW0M1wQoxhM/
         HETHyaj9iAKWjVERD6081ygfBCG2Hi51CX4wc0TR240/q+fXZ2i+hqAG88NASj7asJDu
         cDxg==
Content-Disposition: inline
In-Reply-To: <20180110140239.GX3668920-4dN5La/x3IkLX0oZNxdnEQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Wed, Jan 10, 2018 at 06:02:39AM -0800, Tejun Heo wrote:
> Hello,
> 
> On Wed, Jan 10, 2018 at 04:44:14AM -0800, Roman Gushchin wrote:
> > cgroup.threads is not listed because it's not delegatable (doesn't have
> > CFTYPE_NS_DELEGATABLE flag set). I don't know if it was intended or just
> > an accident (I believe the latter).
> 
> So, thread mode isn't delegatble.  Marking a cgroup as threaded turns
> that subtree threaded and join the parent's domain, so we can't allow
> delegation roots to be turned threaded - just like we can't mark the
> root cgroup threaded, and I'm not really not sure what it means to
> delegate a portion of threaded subtree.

Please disregard.

Just like we can't mark the root cgroup threaded, we can't mark
delegated subtree root's threaded, so cgroup.type is not delegatable.

However, the delegated root's children can definitely be marked
threadaed and they will join the delegated root's domain and the
threads are free to move between root and the threaded subtree.

Thanks.

-- 
tejun
--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
