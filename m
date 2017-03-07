From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 12/19] kernel: convert css_set.refcount from atomic_t to
 refcount_t
Date: Tue, 7 Mar 2017 14:21:54 -0500
Message-ID: <20170307192154.GB31179@htj.duckdns.org>
References: <1487585948-6401-1-git-send-email-elena.reshetova@intel.com>
 <1487585948-6401-13-git-send-email-elena.reshetova@intel.com>
 <20170306195439.GD19696@htj.duckdns.org>
 <2236FBA76BA1254E88B949DDB74E612B41C55AD8@IRSMSX102.ger.corp.intel.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=9kQU2T9d/cFDW01O/L+qVx/LcakvxMwgY+gMQKYiubw=;
        b=Lhdrymr042gQe036NXIrVJ11WaTdyZvjpq6uf+naifsdxit1gbmHYx/LP6u1m+Y+uh
         rRqlfuZnkhjSvtEUoZ+hkHybBd9tAZkjL5m7zDEe18IgUlGA53ZxYQJGU/qDOEckpzzh
         ANRWOJhNhZRvxhiz/RA8ZAlIpsAf9xdjCTVCYRj9J38wWy2MY1bhz2GQASgjHcxy/pC7
         CmjbGWcveoEx1ZNJoiARy70z7wBsQzoucswAvonuJbWHKJ3FEXcJGNPNiDr09zNtVhPt
         gxP3OOMTDL7pu5DYa5jPRS4asHTcNxGgCA7lMs2keLCUrAPT2dT+dKC1glWufcINmnLn
         GtYQ==
Content-Disposition: inline
In-Reply-To: <2236FBA76BA1254E88B949DDB74E612B41C55AD8@IRSMSX102.ger.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Reshetova, Elena" <elena.reshetova@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-audit@redhat.com" <linux-audit@redhat.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "peterz@infradead.org" <peterz@infradead.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "mingo@redhat.com" <mingo@redhat.com>, "hannes@cmpxchg.org" <hannes@cmpxchg.org>, "lizefan@huawei.com" <lizefan@huawei.com>, "acme@kernel.org" <acme@kernel.org>, "alexander.shishkin@linux.intel.com" <alexander.shishkin@linux.intel.com>, "paul@paul-moore.com" <paul@paul-moore.com>, "eparis@redhat.com" <eparis@redhat.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>

Hello,

On Tue, Mar 07, 2017 at 07:12:51PM +0000, Reshetova, Elena wrote:
> Do you want me to resend or could you modify the patch while applying?

Can you please send the updated patch?

Thanks!

-- 
tejun
