From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 08/10] blkcg: implement blk-iocost
Date: Thu, 3 Oct 2019 09:45:52 -0700
Message-ID: <20191003164552.GA3247445@devbig004.ftw2.facebook.com>
References: <20190828220600.2527417-1-tj@kernel.org>
 <20190828220600.2527417-9-tj@kernel.org>
 <20190910125513.GA6399@blackbody.suse.cz>
 <20190910160855.GS2263813@devbig004.ftw2.facebook.com>
 <20191003145106.GC6678@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=cY7dwSAZ/LRC+V3+VuDl/u0CtvPhkHUKtwYdGP4h8tM=;
        b=hLGF2x3mry/9VP8Cgyatm0IMsLfiswwpsqSwtwh3Z2Hay6ZNSrYP6Hl5hSyR5M48qX
         0IPsGhDFHmzedwYhjqPSKXxSwEpjaF1SjvuJ0FK0DlG2SceDEdslkMbvqyN5w454YJEj
         OuwD5C0GKsFxYOH/fjS9taQ1Fao+rvVL7X1AVWbbtq3PQMNMju9lJvlRQgAV3ZyrxHfz
         Zj6wGdAz4K8h7+DjIXPxytnFabB1ZqrIkvVfNl+Es1B4BNAEYSyFz5+rL/yTVGZXslMS
         T9YRxz1/wbsN4CzseBltb1yCaLMVpoVxf5u9viLfyDTGM5uggapI2PAJl/M2cNZb9nJB
         +HVQ==
Content-Disposition: inline
In-Reply-To: <20191003145106.GC6678@blackbody.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Cc: hannes@cmpxchg.org, clm@fb.com, dennisz@fb.com, Josef Bacik <jbacik@fb.com>, kernel-team@fb.com, newella@fb.com, lizefan@huawei.com, axboe@kernel.dk, Paolo Valente <paolo.valente@linaro.org>, Rik van Riel <riel@surriel.com>, josef@toxicpanda.com, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org

Hello,

On Thu, Oct 03, 2019 at 04:51:06PM +0200, Michal Koutn=FD wrote:
> > Initially, I put them under block device sysfs but it was too clumsy
> > with different config file formats and all.
> Do you have any more details on that? In the end, it all boils down to a
> daemon/setup utility writing into the control files and it can use
> whatever config files it decides, can't it?

Yeah, I mean, we can make any interface work.  So, there are two
global knobs io.cost.model and io.cost.qos.  Of the tw, io.cost.model
is okay to move under block device but the qos file gets weird because
the content of the file is more resource control policies than device
properties.

Thanks.

--=20
tejun
