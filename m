From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: (subset) [PATCH 0/9] Documentation: correct lots of spelling errors (series 2)
Date: Tue, 14 Feb 2023 11:57:36 -0500
Message-ID: <167639371119.486235.3812806947516384921.b4-ty@oracle.com>
References: <20230129231053.20863-1-rdunlap@infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-hwmon-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2022-7-12;
 bh=30UhpvvVeEJ74x+BZp2PjN//3LlD3wleEKrKnHvlEME=;
 b=2misEQBvI1JJ+56u+Isk0cVjdv3SudPEHPSoait3o7rcSbIUiV8kvbNovJXev5wnzRRT
 yQ2FDobU5eLDlpUHtycmSVgXhklWuWtXQyHRjAHg4K0sauxjALREy/2VhaHtDgCZdLaF
 WxYI96R7LpJAVqIrrE5IGe7UCpDyG8ufLqpiszIpg2aGbVIFZRZ6w2Y7Tf675ols5O2I
 yfYbzI5S2ct/M57g5be3lojAhGOcNXLEw2X/oeo77pxT6TjnWvmZmiG1mlLR5DMbyBcp
 LmGNOjxpVoIfmfqhy6o1eHoDUtrAQ8cCW6RDnWi5XswKte0lYf8KJhvyj0d5ylUCs/EQ lg== 
In-Reply-To: <20230129231053.20863-1-rdunlap@infradead.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, dm-devel@redhat.com, Mauro Carvalho Chehab <mchehab@kernel.org>, linux-media@vger.kernel.org, linux-mm@kvack.org, Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, nvdimm@lists.linux.dev, Vinod Koul <vkoul@kernel.org>, dmaengine@vger.kernel.org, Song Liu <song@kernel.org>, linux-raid@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org, Jean Delvare <jdelvare@suse.com>

On Sun, 29 Jan 2023 15:10:44 -0800, Randy Dunlap wrote:

> Maintainers of specific kernel subsystems are only Cc-ed on their
> respective patches, not the entire series. [if all goes well]
> 
> These patches are based on linux-next-20230127.
> 
> 
>  [PATCH 1/9] Documentation: admin-guide: correct spelling
>  [PATCH 2/9] Documentation: driver-api: correct spelling
>  [PATCH 3/9] Documentation: hwmon: correct spelling
>  [PATCH 4/9] Documentation: networking: correct spelling
>  [PATCH 5/9] Documentation: RCU: correct spelling
>  [PATCH 6/9] Documentation: scsi/ChangeLog*: correct spelling
>  [PATCH 7/9] Documentation: scsi: correct spelling
>  [PATCH 8/9] Documentation: sparc: correct spelling
>  [PATCH 9/9] Documentation: userspace-api: correct spelling
> 
> [...]

Applied to 6.3/scsi-queue, thanks!

[6/9] Documentation: scsi/ChangeLog*: correct spelling
      https://git.kernel.org/mkp/scsi/c/685d5ef436a9
[7/9] Documentation: scsi: correct spelling
      https://git.kernel.org/mkp/scsi/c/cf065a7da517

-- 
Martin K. Petersen	Oracle Linux Engineering
