From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v4 cgroup/for-3.7] cgroup: mark subsystems with broken
 hierarchy support and whine if cgroups are nested for them
Date: Fri, 14 Sep 2012 14:06:22 -0700
Message-ID: <20120914210622.GU17747@google.com>
References: <20120913183402.GG7677@google.com>
 <20120913192058.GH7677@google.com>
 <20120913194111.GM4396@redhat.com>
 <20120913200354.GN7677@google.com>
 <5052F58E.4050808@parallels.com>
 <5052F61A.3040602@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=khuVDPfuTse8d55wey08VZHal+/MICb5TiVATIj7OWM=;
        b=nAPhdPlMfoKfP61Mv3plogcD/tzsPbJEBvH8z68EpZMTOhGW4UYmatIfRKrV5I1WMb
         pltgqRclpgy1XtBZaM8NADbHBGcJ+tfuUYNVY9mLVuoIHLm6W9H0/eerEITQCT01Avfw
         bQQrkAwkJwYTzh5ea1r9Ytd6CTGYBQ0Q+DOEfex1NauPEaAj7UCCr/fOURe5Ice+K8Pc
         ccC4Uan/0G6Ay9mz3Tui5Kwxt11ICGX01FQbYrAmiaA30xTiN1/zLbrty0q7LjLd6S4P
         jSl2ID0DlNw/IneaadtvMtNIckK3lO1PC5hwOTbu02aOOrtYVbqXJdmBcNf3U0/0kimv
         +pzQ==
Content-Disposition: inline
In-Reply-To: <5052F61A.3040602-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Neil Horman <nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Arnaldo Carvalho de Melo <acme-f8uhVLnGfZaxAyOMLChx1axOck334EZe@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Thomas Graf <tgraf-G/eBtMaohhA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Hello, Glauber.

On Fri, Sep 14, 2012 at 01:17:14PM +0400, Glauber Costa wrote:
> > I side with Vivek, and I think we should warn first level. It just tends
> > to be wrong. If memcg is a special case, just special case it.
> > _but_, I see no reason not to do it.

The issue at hand is how to handle tasks vs. sub-cgroups in the same
cgroup.  memcg doesn't factor into this because it doesn't implement
proportional control.  No matter which way we decide, it doesn't
matter for memcg.

Thanks.

-- 
tejun
