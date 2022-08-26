From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 0/4] Honor cgroup namespace when resolving cgroup id
Date: Fri, 26 Aug 2022 10:59:20 -1000
Message-ID: <Ywk0KCmak/PsGfzL@slm.duckdns.org>
References: <20220826165238.30915-1-mkoutny@suse.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc;
        bh=67ANL95e8WHpoIL2CvpIV5IPIXCkv/6nKh73FiYEZTk=;
        b=biO0zryQaQSqyi8bDdtPfmAl9o+3iq97xCkOIKhxiVmKlGvcUduD2kqjuo/XihSovR
         jCmir/sMxqgFpUwGE0+obcQBUwULaZx+7azsdItRHZpaTPWwHoqQW5eMacjDaFjAfulm
         ZilurnwkbOupUHfy00vdLMFTXNYhvJbvdOcgwppj45evuV8NXTzcbaWHaFuIpvwS/xqh
         v84gT+m6Ht6e1jIEl6ojwrMfk39vFIakBip0EtwK4Hje+CuVM777pW79+8i1tteTosDP
         7k9qC/irsNCjfNM0i1se8cQZGpK+FwngOPznzHe73Te3w8eIJXnLeV6D/TFWuHnNkLfw
         J7Iw==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20220826165238.30915-1-mkoutny@suse.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, bpf@vger.kernel.org, Aditya Kali <adityakali@google.com>, Serge Hallyn <serge.hallyn@canonical.com>, Roman Gushchin <roman.gushchin@linux.dev>, Yonghong Song <yhs@fb.com>, Muneendra Kumar <muneendra.kumar@broadcom.com>, Yosry Ahmed <yosryahmed@google.com>, Hao Luo <haoluo@google.com>

On Fri, Aug 26, 2022 at 06:52:34PM +0200, Michal Koutn=FD wrote:
> Cgroup id is becoming a new way for userspace how to refer to cgroups it
> wants to act upon. As opposed to cgroupfs (paths, opened FDs), the
> current approach does not reflect limited view by (non-init) cgroup
> namespaces.
>=20
> This patches don't aim to limit what a user can do (consider an uid=3D0 in
> mere cgroup namespace) but to provide consistent view within a
> namespace.

Applied 1-3 to cgroup/for-6.1. The branch will be stable, so please feel
free to pull from bpf/for-next.

Thanks.

--=20
tejun
