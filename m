From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] Documentation: cgroup-v2: eliminate markup warnings
Date: Fri, 8 Feb 2019 09:01:50 -0800
Message-ID: <20190208170150.GK50184@devbig004.ftw2.facebook.com>
References: <7ba0d6eb-8f45-7f4d-4e84-53dab1158da4@infradead.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=lGI1b90+7lYWM0s1T2HpYMGvNcMnNrIxPnTv5GxwsM0=;
        b=UnMSSAZs66S/hfxO2XxunZCkHAq9/NUTbbj0q0AstJWVPZpkrnzRPLLpJRZyCIaitQ
         hL0BGhJYbYq+YWRogwHcT4OtEqwpqp4O+I3hqv6Qjq1/v9Ev2TKznNsID5jKWBqKgG3+
         hN9zcXfnjvvs44MEqF6K6UM/9bJzhV3iXU9ciFGfxJlfdCwHvlizb3rV+DWZ85ACAVE5
         +VF0dQrwY97aVKZZKRgwBqXNitGraHoHiFAarjjPMx3pQsesVuaCJl2i7enmKaQ6vcbi
         WtU0CBB6fTJ77qULESA3x9T6O8wkBDmMlLUfgNDqlm8UOzCDhVntFqTXG/UNdNbUPhgM
         P9jQ==
Content-Disposition: inline
In-Reply-To: <7ba0d6eb-8f45-7f4d-4e84-53dab1158da4@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Randy Dunlap <rdunlap@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org

On Wed, Feb 06, 2019 at 04:59:00PM -0800, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@infradead.org>
> 
> Fix markup warnings in cgroup-v2.rst:
> 
> Documentation/admin-guide/cgroup-v2.rst:1509: WARNING: Block quote ends without a blank line; unexpected unindent.
> Documentation/admin-guide/cgroup-v2.rst:1511: WARNING: Block quote ends without a blank line; unexpected unindent.
> Documentation/admin-guide/cgroup-v2.rst:1512: WARNING: Block quote ends without a blank line; unexpected unindent.
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Li Zefan <lizefan@huawei.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: cgroups@vger.kernel.org
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: linux-doc@vger.kernel.org

Applied to cgroup/for-5.0.

Thanks.

-- 
tejun
