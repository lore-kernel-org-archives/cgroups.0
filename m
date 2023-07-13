From: Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH 0/2] eventfd: simplify signal helpers
Date: Thu, 13 Jul 2023 11:10:54 -0600
Message-ID: <20230713111054.75cdf2b8.alex.williamson@redhat.com>
References: <20230713-vfs-eventfd-signal-v1-0-7fda6c5d212b@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <intel-gfx-bounces@lists.freedesktop.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1689268260;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=+UPgPFBGvQHuZjwqO9ik4oPicS3MZwipCdBIqa3Pous=;
 b=gNfBuFkf0gGu6EVWbDwoyiU8boJV7eRq6L3WSboaHg0RAldYAOV74SvuSMS+x9W+rsPL/m
 BKOFbjtxsjuIxIyC6zdpsd+oXETnMFGRgtb7c+TCRAtzOQbPlNeRoBjm9fX9rU5uS/IkH4
 Utl8POcE6XSSrdOtWXvbguHI7QlEQoE=
In-Reply-To: <20230713-vfs-eventfd-signal-v1-0-7fda6c5d212b@kernel.org>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/intel-gfx>,
 <mailto:intel-gfx-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/intel-gfx>
List-Post: <mailto:intel-gfx@lists.freedesktop.org>
List-Help: <mailto:intel-gfx-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/intel-gfx>,
 <mailto:intel-gfx-request@lists.freedesktop.org?subject=subscribe>
Errors-To: intel-gfx-bounces@lists.freedesktop.org
Sender: "Intel-gfx" <intel-gfx-bounces@lists.freedesktop.org>
Content-Type: text/plain; charset="us-ascii"
To: Christian Brauner <brauner@kernel.org>
Cc: linux-aio@kvack.org, Muchun Song <muchun.song@linux.dev>, Tony Krowiak <akrowiak@linux.ibm.com>, Matthew Rosato <mjrosato@linux.ibm.com>, Paul Durrant <paul@xen.org>, Tom Rix <trix@redhat.com>, Jason Wang <jasowang@redhat.com>, Roman Gushchin <roman.gushchin@linux.dev>, dri-devel@lists.freedesktop.org, Michal Hocko <mhocko@kernel.org>, Heiko Carstens <hca@linux.ibm.com>, linux-mm@kvack.org, Kirti Wankhede <kwankhede@nvidia.com>, Vineeth Vijayan <vneethv@linux.ibm.com>, Diana Craciun <diana.craciun@oss.nxp.com>, Borislav Petkov <bp@alien8.de>, Alexander Gordeev <agordeev@linux.ibm.com>, Fei Li <fei1.li@intel.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Arnd Bergmann <arnd@arndb.de>, Leon Romanovsky <leon@kernel.org>, jaz@semihalf.com, linux-rdma@vger.kernel.org, x86@kernel.org, Halil Pasic <pasic@linux.ibm.com>, Jason Gunthorpe <jgg@ziepe.ca>, Ingo Molnar <mingo@redhat.co>

On Thu, 13 Jul 2023 12:05:36 +0200
Christian Brauner <brauner@kernel.org> wrote:

> Hey everyone,
> 
> This simplifies the eventfd_signal() and eventfd_signal_mask() helpers
> by removing the count argument which is effectively unused.

We have a patch under review which does in fact make use of the
signaling value:

https://lore.kernel.org/all/20230630155936.3015595-1-jaz@semihalf.com/

Thanks,
Alex

