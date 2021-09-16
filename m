From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Subject: Re: [PATCH v3 3/3] docs/cgroup: add entry for misc.events
Date: Thu, 16 Sep 2021 19:47:35 +0200
Message-ID: <20210916174735.GA12271@blackbody.suse.cz>
References: <3834f917d50a6f19402e179e917ef6a9dde5f64a.1631671936.git.brookxu@tencent.com>
 <7cb32b92b77188f50b46bb47eb728bcacf18c17f.1631671936.git.brookxu@tencent.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1631814456; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=92sbNZ4wtt7HJbLDVek/qCHTZYn/db8qMt1chWEKSus=;
        b=QxXUahxQZ+eYlKdrdkwUUz1H1yNVburuoAS/zqp9XPPRLN8gqTzaSP8TKq+nMOUsv1RPtE
        CJgaLN5eFXNtCcIu37SJ0qE2IbJMb5GHevpOLPbv9JbhgHPte9kJjt7El4FT0VEvPH76HM
        DPuNlKRa8XTHg9F4I6QYYbHFDgj+iFo=
Content-Disposition: inline
In-Reply-To: <7cb32b92b77188f50b46bb47eb728bcacf18c17f.1631671936.git.brookxu@tencent.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: brookxu <brookxu.cn@gmail.com>
Cc: tj@kernel.org, lizefan.x@bytedance.com, hannes@cmpxchg.org, vipinsh@google.com, corbet@lwn.net, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org

On Wed, Sep 15, 2021 at 10:18:51AM +0800, brookxu <brookxu.cn@gmail.com> wr=
ote:
> From: Chunguang Xu <brookxu@tencent.com>
>=20
> Added descriptions of misc.events.
>=20
> Signed-off-by: Chunguang Xu <brookxu@tencent.com>
> ---
>  Documentation/admin-guide/cgroup-v2.rst | 10 ++++++++++
>  1 file changed, 10 insertions(+)

Reviewed-by: Michal Koutn=FD <mkoutny@suse.com>

