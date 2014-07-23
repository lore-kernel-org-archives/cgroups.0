From: Tejun Heo <tj@kernel.org>
Subject: Re: WARNING: at kernel/cpuset.c:1139
Date: Wed, 23 Jul 2014 11:12:20 -0400
Message-ID: <20140723151220.GD7103@htj.dyndns.org>
References: <53CF22F5.6000206@linux.vnet.ibm.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=ojr09V4jXJwAFtZMNvFx/XAinaeGWoRbuoURAtWdWiU=;
        b=sQofewE/ZfbKdPI+insKKf4ku7lNiZ+3CkHpHS2E5xUR2lr5i5yxXdprf8AApNQplH
         xZCqEn2OoBtqdDSFuDefNhucYrPzUdKdN4RlR2lHLfo5P4un8dFmxw2+iDXrxrOuq3yh
         a1+WFsGpS2HG0a0nH+79wJorCn0ON+JAS+6K7HgDlFwurZEZghilRXdkYpMCuWc5AkPz
         ZF53rc2gyBNL+M0/WLN9rslxoqoOrELOdbaZCk5wWHJ5gaoNuBrwtxgxmmksi8asFIK8
         dewqfmLwNG7BPzBRhTUcLP+CapL1HW7qnzuhaMO0/0UdOdi0vPD+KmNVY98GdtUh/ewi
         D+eQ==
Content-Disposition: inline
In-Reply-To: <53CF22F5.6000206@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mike Qiu <qiudayu@linux.vnet.ibm.com>
Cc: cgroups@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, lizefan@huawei.com

On Wed, Jul 23, 2014 at 10:50:29AM +0800, Mike Qiu wrote:
> commit 734d45130cb ("cpuset: update cs->effective_{cpus, mems} when config
> changes") introduce the below warning in my server.
> 
> [   35.652137] ------------[ cut here ]------------
> [   35.652141] WARNING: at kernel/cpuset.c:1139

Hah, can you reproduce it?  If so, can you detail how?

Thanks.

-- 
tejun
