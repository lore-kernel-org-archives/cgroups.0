From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: Re: [PATCH v4] mm: oom: introduce cpuset oom
Date: Tue, 11 Apr 2023 15:12:34 +0200
Message-ID: <ZDVcwuiu3rWEFiTE@dhcp22.suse.cz>
References: <20230411065816.9798-1-ligang.bdlg@bytedance.com>
 <3myr57cw3qepul7igpifypxx4xd2buo2y453xlqhdw4xgjokc4@vi3odjfo3ahc>
 <aa3382b4-4046-988f-42ea-8812dba7882b@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1681218755; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VNlFRQuYhtU71A5sBtEqauVXSAM4+ELeuv9fRTR/B+8=;
        b=N3D9s54Cj7iVAGl3df2xdmODccoQe5g3gpxR/8FgOto6W6miPDufLxBAI1dKerUC33V0e3
        ZmdpqwbnwZywWA363KMPUG+hVUJK90Uivdmur+G67+EBIcBRhGlxkSg+zch2ZVqdDRD49O
        qdirTKxhGLmkRu86zzmZkrGX169YhMc=
Content-Disposition: inline
In-Reply-To: <aa3382b4-4046-988f-42ea-8812dba7882b-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Gang Li <ligang.bdlg-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue 11-04-23 21:04:18, Gang Li wrote:
>=20
>=20
> On 2023/4/11 20:23, Michal Koutn=FD wrote:
> > Hello.
> >=20
> > On Tue, Apr 11, 2023 at 02:58:15PM +0800, Gang Li <ligang.bdlg-EC8Uxl6N=
pydl57MIdRCFDg@public.gmane.org> wrote:
> > > +	cpuset_for_each_descendant_pre(cs, pos_css, &top_cpuset) {
> > > +		if (nodes_equal(cs->mems_allowed, task_cs(current)->mems_allowed))=
 {
> > > +			css_task_iter_start(&(cs->css), CSS_TASK_ITER_PROCS, &it);
> > > +			while (!ret && (task =3D css_task_iter_next(&it)))
> > > +				ret =3D fn(task, arg);
> > > +			css_task_iter_end(&it);
> > > +		}
> > > +	}
> > > +	rcu_read_unlock();
> > > +	cpuset_read_unlock();
> > > +	return ret;
> > > +}
> >=20
> > I see this traverses all cpusets without the hierarchy actually
> > mattering that much. Wouldn't the CONSTRAINT_CPUSET better achieved by
> > globally (or per-memcg) scanning all processes and filtering with:
>=20
> Oh I see, you mean scanning all processes in all cpusets and scanning
> all processes globally are equivalent.

Why cannot you simple select a process from the cpuset the allocating
process belongs to? I thought the whole idea was to handle well
partitioned workloads.

> > 	nodes_intersect(current->mems_allowed, p->mems_allowed
>=20
> Perhaps it would be better to use nodes_equal first, and if no suitable
> victim is found, then downgrade to nodes_intersect?

How can this happen?

> NUMA balancing mechanism tends to keep memory on the same NUMA node, and
> if the selected victim's memory happens to be on a node that does not
> intersect with the current process's node, we still won't be able to
> free up any memory.

AFAIR NUMA balancing doesn't touch processes with memory policies.
--=20
Michal Hocko
SUSE Labs
