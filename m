From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 18/18] ioasid: Add /dev/ioasid for userspace
Date: Wed, 10 Mar 2021 15:23:01 -0400
Message-ID: <20210310192301.GC2356281@nvidia.com>
References: <1614463286-97618-1-git-send-email-jacob.jun.pan@linux.intel.com>
 <1614463286-97618-19-git-send-email-jacob.jun.pan@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F9vW5Tkli/mGOXhgNDkiWxksYvTGh56Erxhualjjxwc=;
 b=LaXeEE8/z8xKwzOnzuOHFOraxwyZ4k4XccBmPjvoy2x9oSfZ1vT0VnPlV1BL+9aH+F3tqxaytcPbjqKMqIg79Xdo12+0pV4y/l8pIYcV51XnWlw8a8pqMqNkcY/yFNu3Zb3Hev6uZx5yq+HV1BjFVkmNoou1bsK8LRXAHd3fqQTswur7Q7VHNaC/mW1lq52x5pPCKN3t1Q7/Do+PfLRix9V6deI9tZTgmjcgYnxo08TRqhz4aaUJJFhSzEXwb/BjJA933SVHpS7inLZo1JnIsUELtMyUvSqQ8z6hSpNYXnF7xhmXe6snJxJ43jz0qLKpeIE1/Oned/IRWVvZdeR2ng==
Content-Disposition: inline
In-Reply-To: <1614463286-97618-19-git-send-email-jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
 <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
 <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Sender: "iommu" <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
To: Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Raj Ashok <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dave Jiang <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

On Sat, Feb 27, 2021 at 02:01:26PM -0800, Jacob Pan wrote:

> +/* -------- IOCTLs for IOASID file descriptor (/dev/ioasid) -------- */
> +
> +/**
> + * IOASID_GET_API_VERSION - _IO(IOASID_TYPE, IOASID_BASE + 0)
> + *
> + * Report the version of the IOASID API.  This allows us to bump the entire
> + * API version should we later need to add or change features in incompatible
> + * ways.
> + * Return: IOASID_API_VERSION
> + * Availability: Always
> + */
> +#define IOASID_GET_API_VERSION		_IO(IOASID_TYPE, IOASID_BASE + 0)

I think this is generally a bad idea, if you change the API later then
also change the ioctl numbers and everything should work out

eg use the 4th argument to IOC to specify something about the ABI

Jason
