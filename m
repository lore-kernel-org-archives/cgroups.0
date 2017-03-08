From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] kernel: convert css_set.refcount from atomic_t to
 refcount_t
Date: Wed, 8 Mar 2017 17:47:19 -0500
Message-ID: <20170308224719.GA21117@htj.duckdns.org>
References: <1488960040-24741-1-git-send-email-elena.reshetova@intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=hRa6nC1a2lo3QHm/M2f1LW/A4C+cIF/F0S9Rss0FS8A=;
        b=l6VfHpiGOQ8l56xQieRagMHNHHFifRbIJjmDknzI9Ki7YgbrvSFh9PxHoqkpBmErr6
         PnfhGnySSbocS5Tf41xe7lFhjFOJ6TVj39iLqc6L6kr2Purrc96n3EQOdorIVbElrK2D
         gS8fNWI7a4cy9QGiGvNMpyknkddIHTkSXMIqDulCV+2wTo5NawHaW3UbgCKwOBc7czAQ
         Uv7mIfGqVNAv3dHwk46Wm9CYTz3Y1uu7+qfebUqDBMMFONWnvrhXm8zmjkT6Y35K8WBh
         M4u5VhKStd27KH3CWuygoNuQqSlbjHLmIkJja/WI6BaMtZJ+upEdqhznvI+U9fjMHbBF
         5e6Q==
Content-Disposition: inline
In-Reply-To: <1488960040-24741-1-git-send-email-elena.reshetova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Elena Reshetova <elena.reshetova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hans Liljestrand <ishkamiel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, David Windsor <dwindsor-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Wed, Mar 08, 2017 at 10:00:40AM +0200, Elena Reshetova wrote:
> refcount_t type and corresponding API should be
> used instead of atomic_t when the variable is used as
> a reference counter. This allows to avoid accidental
> refcounter overflows that might lead to use-after-free
> situations.
> 
> Signed-off-by: Elena Reshetova <elena.reshetova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Hans Liljestrand <ishkamiel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
> Signed-off-by: David Windsor <dwindsor-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Applied to cgroup/for-4.12.

Thanks.

-- 
tejun
