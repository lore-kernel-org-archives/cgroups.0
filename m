From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC PATCH 15/18] cgroup: Introduce ioasids controller
Date: Wed, 3 Mar 2021 10:44:28 -0500
Message-ID: <YD+u3CXhwOi2LC+4@slm.duckdns.org>
References: <1614463286-97618-1-git-send-email-jacob.jun.pan@linux.intel.com>
 <1614463286-97618-16-git-send-email-jacob.jun.pan@linux.intel.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yAenZ2k324Y74inyHnLSpf4GKMijWe+eb5zJ0f7us3Y=;
        b=Yo/WbLtNEcukoBaVIbtOmoJkqQ78eohGvlv9L6yTWcdDIuU+1DKAsD3fh1HE47Xrp+
         QFlB7j0powGVx/NAToiiojNwZYwizMSL3bMhnmCO5LXvVsufMjP7GNnPm8L/4Z04DNED
         PwkvridEsCPsRoNu/6CyDKV6GbFO6q2fPyLhHKJnUfbBGoKhaEDc7kAAkZXc5ASnjGnj
         COSukL6HNRaAnW+dWsCVUTEWV6O1Sj57SBKzdk7nqI1XHIiwgqRSH+n321SqE/5pCgGy
         ZRtUeRAi9hqP8qbDLI7pXQc3l3kAvlrBrJ0G4HVsFGa3WxRqSwAhAuIuaJFI+TFc8FpN
         EZ4A==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <1614463286-97618-16-git-send-email-jacob.jun.pan@linux.intel.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Joerg Roedel <joro@8bytes.org>, Lu Baolu <baolu.lu@linux.intel.com>, David Woodhouse <dwmw2@infradead.org>, iommu@lists.linux-foundation.org, cgroups@vger.kernel.org, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Jean-Philippe Brucker <jean-philippe@linaro.com>, Alex Williamson <alex.williamson@redhat.com>, Eric Auger <eric.auger@redhat.com>, Jason Gunthorpe <jgg@nvidia.com>, Jonathan Corbet <corbet@lwn.net>, Raj Ashok <ashok.raj@intel.com>, "Tian, Kevin" <kevin.tian@intel.com>, Yi Liu <yi.l.liu@intel.com>, Wu Hao <hao.wu@intel.com>, Dave Jiang <dave.jiang@intel.com>

On Sat, Feb 27, 2021 at 02:01:23PM -0800, Jacob Pan wrote:
> IOASIDs are used to associate DMA requests with virtual address spaces.
> They are a system-wide limited resource made available to the userspace
> applications. Let it be VMs or user-space device drivers.
> 
> This RFC patch introduces a cgroup controller to address the following
> problems:
> 1. Some user applications exhaust all the available IOASIDs thus
> depriving others of the same host.
> 2. System admins need to provision VMs based on their needs for IOASIDs,
> e.g. the number of VMs with assigned devices that perform DMA requests
> with PASID.

Please take a look at the proposed misc controller:

 http://lkml.kernel.org/r/20210302081705.1990283-2-vipinsh@google.com

Would that fit your bill?

Thanks.

-- 
tejun
