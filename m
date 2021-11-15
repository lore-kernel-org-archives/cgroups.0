From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: rstat: Mark benign data race to silence KCSAN
Date: Mon, 15 Nov 2021 11:34:52 -1000
Message-ID: <YZLSfFVKVFqLj3sP@slm.duckdns.org>
References: <20211103165845.38226-1-mkoutny@suse.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=vAeLeuKX9qzkFBsusVD2f4vveg/1KTUzCbxhrs8CM/4=;
        b=Fd7ClpIxpg8cp11Uf8eilB6WH6poftTDXKGP02+MkoM4XmqYtZUX4s4lxJUglLCSvk
         +Ku2zFyCfFmKbOlXK3eU4gcrdFDtNLFF94bChw0gh4j/Lq6DPqCn1nXt9+/0WS3FHHgT
         N7SymUa7BOx2GIf0j7B6G/smoCSgDZ9H5xLHEHl9or250PSJjGae3lFsUSxwELIb9/n5
         90XdvnHe7MhrVlxwuhpl1AwKN8Jobm36xLqchAQSBB20gz4tp7Ozv4wnsqiUOZl9bwVQ
         vHS+4PRUgP1ePVRESjj/6SqIHfF5qQ4TKxW8pNct7MfnQC9y/VA6W32T7TqiZbIMWEdh
         mJWQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20211103165845.38226-1-mkoutny-IBi9RG/b67k@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Hao Sun <sunhao.th-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Nov 03, 2021 at 05:58:45PM +0100, Michal Koutn=FD wrote:
> There is a race between updaters and flushers (flush can possibly miss
> the latest update(s)). This is expected as explained in
> cgroup_rstat_updated() comment, add also machine readable annotation so
> that KCSAN results aren't noisy.
>=20
> Reported-by: Hao Sun <sunhao.th-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Link: https://lore.kernel.org/r/CACkBjsbPVdkub=3De-E-p1WBOLxS515ith-53SFd=
mFHWV_QMo40w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org
> Suggested-by: Hao Sun <sunhao.th-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>=20
> Signed-off-by: Michal Koutn=FD <mkoutny-IBi9RG/b67k@public.gmane.org>

Applied to cgroup/for-5.17.

Thanks.

--=20
tejun
