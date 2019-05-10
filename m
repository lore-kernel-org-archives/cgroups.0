From: "Ardelean, Alexandru" <alexandru.Ardelean@analog.com>
Subject: Re: [PATCH 09/16] mmc: sdhci-xenon: use new match_string()
 helper/macro
Date: Fri, 10 May 2019 09:13:26 +0000
Message-ID: <31be52eb1a1abbc99a24729f5c65619235cb201f.camel@analog.com>
References: <20190508112842.11654-1-alexandru.ardelean@analog.com>
 <20190508112842.11654-11-alexandru.ardelean@analog.com>
 <20190508122010.GC21059@kadam>
 <2ec6812d6bf2f33860c7c816c641167a31eb2ed6.camel@analog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=lists.infradead.org; s=bombadil.20170209; h=Sender:
	Content-Transfer-Encoding:Content-Type:Cc:List-Subscribe:List-Help:List-Post:
	List-Archive:List-Unsubscribe:List-Id:MIME-Version:Content-ID:In-Reply-To:
	References:Message-ID:Date:Subject:To:From:Reply-To:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	List-Owner; bh=IHYiGcoKQTeJ1CMbAdF/LZox82wIoRGG+exysKhQlHY=; b=OIvhz5qYopqueU
	eIv1boqQpOpwFZRdVZXWaewhPrMigaLeihIWtYtmY4owawEINdxf8YcXDcoTNHB13ja3A3AfZ/sY5
	FHZ8qSElLjdl7dhgAnY+CnlFvSi/FsB0/KWYoMDJITz46oHzCBfUAU1u+QEypr2fZjjW5nkwEHvpC
	B3Wi7/xzG8F54Aw1UVnU7Iv8Mk1oyVo4ntsXkhocuDUoMFEFXIlwka5SK8i/RS9irbtQqroaB+zRE
	f2IOiA00bi6mF+2rKfifxcn+eNSDryPs0E3KskXUOlUU0fYC89A2yxYKPWKFXqW4CShPcOsbfVSfz
	9flj9EM3HRmiYVKSAE5w==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector1-analog-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cd+V8yqGMykCDx3832Gazx49N+DzcZoh0jyuHRt5ol4=;
 b=UtgaGDmS/mFN7LqP4rRanlhIErtROJDfXKgcIeQ1c2pUsTHgWkYu7j96Yd2lPftDdz2wXx3xkpYor7R+H8gftiZOSJxx+ATBAk9fPgRuYm3L0Lav4JU1SKRoMBgfFlLd2aeYeN4GFuH2989f+gy+Ay1+8Dk0VQ9Sau1g+bv3pvo=
In-Reply-To: <2ec6812d6bf2f33860c7c816c641167a31eb2ed6.camel@analog.com>
Content-Language: en-US
Content-ID: <BB59C46108248B4E9B7153CD2DF23B7C@analog.com>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>, 
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>, 
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: "dan.carpenter@oracle.com" <dan.carpenter@oracle.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>, "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>, "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>, "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>, "andriy.shevchenko@linux.intel.com" <andriy.shevchenko@linux.intel.com>, "linux-rockchip@lists.infradead.org" <linux-rockchip@lists.infradead.org>, "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>, "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>, linux-gpio@vger.kernel.or

On Wed, 2019-05-08 at 16:26 +0300, Alexandru Ardelean wrote:
> On Wed, 2019-05-08 at 15:20 +0300, Dan Carpenter wrote:
> > 
> > 
> > On Wed, May 08, 2019 at 02:28:35PM +0300, Alexandru Ardelean wrote:
> > > -static const char * const phy_types[] = {
> > > -     "emmc 5.0 phy",
> > > -     "emmc 5.1 phy"
> > > -};
> > > -
> > >  enum xenon_phy_type_enum {
> > >       EMMC_5_0_PHY,
> > >       EMMC_5_1_PHY,
> > >       NR_PHY_TYPES
> > 
> > There is no need for NR_PHY_TYPES now so you could remove that as well.
> > 
> 
> I thought the same.
> The only reason to keep NR_PHY_TYPES, is for potential future patches,
> where it would be just 1 addition
> 
>  enum xenon_phy_type_enum {
>       EMMC_5_0_PHY,
>       EMMC_5_1_PHY,
> +      EMMC_5_2_PHY,
>       NR_PHY_TYPES
>   }
> 
> Depending on style/preference of how to do enums (allow comma on last
> enum
> or not allow comma on last enum value), adding new enum values woudl be 2
> additions + 1 deletion lines.
> 
>  enum xenon_phy_type_enum {
>       EMMC_5_0_PHY,
> -      EMMC_5_1_PHY
> +      EMM
> C_5_1_PHY,
> +      EMMC_5_2_PHY
>  }
> 
> Either way (leave NR_PHY_TYPES or remove NR_PHY_TYPES) is fine from my
> side.
> 

Preference on this ?
If no objection [nobody insists] I would keep.

I don't feel strongly about it [dropping NR_PHY_TYPES or not].

Thanks
Alex

> Thanks
> Alex
> 
> > regards,
> > dan carpenter
> > 
