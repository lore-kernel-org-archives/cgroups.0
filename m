From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC 0/4] cgroup hierarchy controls and stats
Date: Wed, 2 Aug 2017 12:06:39 -0700
Message-ID: <20170802190639.GM2311718@devbig577.frc2.facebook.com>
References: <20170802165532.22277-1-guro@fb.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=U0Oq8Xcc8Jzf/WfbkqVUioTCgfgh6GE4jR8rr0zu4Os=;
        b=h9ypMQsW3Iy/vVRhL5ugKIxxhW1e06U71SLVtJbNDeokA3HD50OPVRMUACBu72JjFq
         WeISzGp+ru/hgNgubX6w+9wKTZWXm9YWoAjKZCpycT/eP1vnygrAmupXBjQgfShh7PMc
         NPjkt/Wmehrd5qs7JGWrs54rUsqwFysVDZd12rGdJ4toSEg8eMr65CIYTYGKDFmDYeQt
         Z5q4I7iCcVqE5MG7iN0loJubcJ3/eC0sjys0JjxPLo+OkoEghr0TLOJy5ZsKLU0GSBnG
         n0yOc/AlRZTI4d4t02TKV9dJw5MDZapnajdZlFzPc/KaO5prEZixoU7Ce7rzg9AH2YSF
         LzXQ==
Content-Disposition: inline
In-Reply-To: <20170802165532.22277-1-guro-b10kYP2dOMg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Wed, Aug 02, 2017 at 05:55:28PM +0100, Roman Gushchin wrote:
> Creating cgroup hierearchies of an unreasonable size can affect
> system performance. A user might want to limit the size
> of the cgroup hierarchy.
> 
> This patchset implements an ability to control and monitor cgroup
> hierarchy size.
> 
> Patch 1 implements tracking of live and dying descendant cgroups
>         on each cgroup level.
> Patch 2 adds cgroup.max.descendants and cgroup.max.depth interfaces
>         to set up hierarchy limits.
> Patch 3 adds cgroup.stat interface with simple hierarchy stats.
> Patch 4 is a trivial cleanup.

Applied 1-4 to cgroup/for-4.14.  We *might* have further discussions
on the specifics of the interface but in terms of feature and internal
implementation, I don't think there's anything which can be
controversial.

Thanks.

-- 
tejun
