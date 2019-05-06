From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2 57/79] docs: accounting: convert to ReST
Date: Mon, 6 May 2019 08:46:36 -0700
Message-ID: <20190506154636.GR374014@devbig004.ftw2.facebook.com>
References: <cover.1555938375.git.mchehab+samsung@kernel.org>
 <13b52516ab787b9a9637e6b9adfec88ec1931b99.1555938376.git.mchehab+samsung@kernel.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=lXQvw+zp+N33bb9guBw4WQqWlonXTLii4rMWOOFeOIg=;
        b=dU2NZXWQ7YnYb9ycqqTB+h49uzgmVKDADAwnHw9iWFp9wip3Tc0RdRVxac66mNuTgk
         4bim278kH1u2eNKoD84smILsRZONvqoTibhBF40u9Qw2YnorGSrAeRc7fcbbv9zQKR1q
         pnExSVmOitOgU3ppFENP6TS4v4e2pJ/ptx073lkTQIUcDrgRLkipVT4ho50UrV1cQqzh
         J82vr7UysGFU4nYFWfgR9i7QGIHYc7BzHhiDLyn+4oFiCFbTdCoFIMnlNIrJvjvPgR/0
         423pRGLqM6++O18qV1iWgBk6nekzRNwMKL/oGk5kOaB0h64Wq5pg8o2uhlOzZX9kLtZE
         dqSA==
Content-Disposition: inline
In-Reply-To: <13b52516ab787b9a9637e6b9adfec88ec1931b99.1555938376.git.mchehab+samsung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Linux Doc Mailing List <linux-doc@vger.kernel.org>, Mauro Carvalho Chehab <mchehab@infradead.org>, linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, Balbir Singh <bsingharora@gmail.com>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org

On Mon, Apr 22, 2019 at 10:27:46AM -0300, Mauro Carvalho Chehab wrote:
> Rename the accounting documentation files to ReST, add an
> index for them and adjust in order to produce a nice html
> output via the Sphinx build system.
> 
> At its new index.rst, let's add a :orphan: while this is not linked to
> the main index.rst file, in order to avoid build warnings.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
