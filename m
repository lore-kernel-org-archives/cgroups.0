From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and
 allocation APIs
Date: Wed, 26 May 2021 16:13:22 -0300
Message-ID: <20210526191322.GQ1002214@nvidia.com>
References: <YIoiJRY3FM7xH2bH@yekko>
 <20210503161518.GM1370958@nvidia.com>
 <YJy9o8uEZs42/qDM@yekko>
 <20210513135938.GG1002214@nvidia.com>
 <YKtbWo7PwIlXjFIV@yekko>
 <20210524233744.GT1002214@nvidia.com>
 <ce2fcf21-1803-047b-03f0-7a4108dea7af@nvidia.com>
 <20210525165252.6959d9da.alex.williamson@redhat.com>
 <6f9dad1a-4e15-1703-d6f4-1b51b7fde15a@nvidia.com>
 <20210526125905.61e00a18.alex.williamson@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SWuO9e9xT6uCDc51InbjAXoSqaQdVWoQ3GqsT4SVE+I=;
 b=mC8Vk/BZMuGQ9+dcKC5CDBQPUR3rAIEcSdoIlDqhxH3QcefGTHvP2JwdDyk1Vr0LR/8yhPCaj8c1EyH8mD8k9YsowGQRXQhYSUd4RrDoTtpIIB3LT4/sXNUJpOc5T0nDtDA/wIPZ2suXtpzJ27edmulW7B24RLIBI/gQZsVJnmo+C11BnFZiGZIQo5ILYspY7j4/whNet1uRlWvwojzy2iSgUaD4OdRg283oeiaKz5o1ZOE5VaV1ct6cspZq/nAhgS1oKM/Ut4kerzrQsdSIo75+IdV0so16xphObhkQdJxo3W2FtEUHi9ips9nnYNO8xGoFQEGSceDUTkZYwDNItQ==
Content-Disposition: inline
In-Reply-To: <20210526125905.61e00a18.alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Kirti Wankhede <kwankhede-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, David Gibson <david-xT8FGy+AXnRB3Ne2BGzF6laj5H9X9Tb+@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Jiang, Dave" <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Raj, Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Wu, Hao" <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

On Wed, May 26, 2021 at 12:59:05PM -0600, Alex Williamson wrote:

> A driver provided sysfs attribute would obviously fill the short
> term gap, long term maybe this would be standardized via netlink.  It
> seems a bit analogous to setting the MAC address for a VF on an SR-IOV
> NIC or VF namespace configuration for an SR-IOV NVMe device.  Thanks,

We have been doing a lot of work in netlink/devlink to program the VF
settings before starting the VF driver

I've long thought it would be good to standardize a VF lifecycle in
Linux eg VFs start their life in some 'unconfigured' state and drivers
don't bind, then userspace can use the PF to perform configuration,
finally the driver can start on a configured VF

We are already doing this model for the mlx5 'sub function' interfaces
which have alot of analogs to both VFs and Intel's SIOV ADIs. It seems
to be working.

Jason
