From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v4 1/3] misc_cgroup: introduce misc.events to count
 failures
Date: Mon, 20 Sep 2021 07:36:31 -1000
Message-ID: <YUjGn27Ryt5R6Cs7@slm.duckdns.org>
References: <3834f917d50a6f19402e179e917ef6a9dde5f64a.1631881726.git.brookxu@tencent.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=OU4xzWoGEyQRbV0io9yUzpEtxuso6DGtbaEY+PN0yXY=;
        b=UWm0G1Ww+g5nv8MIKnO9ITpymPJN2u7uYFkxWjd1PUOcBKrjfgli6E6founBl6k+y7
         us7VaQS55ELql0B4EdD5cV8NqN1IxNwwd+9oedfl6poL49bXXjSDXBzJ3uigtvICUf9/
         i1mtFj17iiz7RRsQHxYfUoMWWcraEXtiL/2V4NFXA2RCVHPSYYrp8LZA4t7Ep+T62X1i
         +9hg5760L5nZ9bEQM14936PQHk8HOHG74410RUjD37TIJkEtRL/xaydv80IX2XgDMr5Q
         nZfw6O64Rv8W6V9G9a6OIrlh8PIfZy3zavqTOu71sEaQwsz3LyQNBApDYOAcZ2GTG+Li
         X4Cw==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <3834f917d50a6f19402e179e917ef6a9dde5f64a.1631881726.git.brookxu@tencent.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: brookxu <brookxu.cn@gmail.com>
Cc: lizefan.x@bytedance.com, hannes@cmpxchg.org, vipinsh@google.com, mkoutny@suse.com, corbet@lwn.net, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org

On Fri, Sep 17, 2021 at 08:44:14PM +0800, brookxu wrote:
> From: Chunguang Xu <brookxu@tencent.com>
>=20
> Introduce misc.events to make it easier for us to understand
> the pressure of resources. Currently only the 'max' event is
> implemented, which indicates the times the resource is about
> to exceeds the max limit.
>=20
> Signed-off-by: Chunguang Xu <brookxu@tencent.com>
> Reviewed-by: Vipin Sharma <vipinsh@google.com>
> Reviewed-by: Michal Koutn=FD <mkoutny@suse.com>

Applied 1-3 to cgroup/for-5.16.

Thanks.

--=20
tejun
