From: "Ardelean, Alexandru" <alexandru.Ardelean@analog.com>
Subject: Re: [PATCH 09/16] mmc: sdhci-xenon: use new match_string()
 helper/macro
Date: Wed, 8 May 2019 13:26:29 +0000
Message-ID: <2ec6812d6bf2f33860c7c816c641167a31eb2ed6.camel@analog.com>
References: <20190508112842.11654-1-alexandru.ardelean@analog.com>
 <20190508112842.11654-11-alexandru.ardelean@analog.com>
 <20190508122010.GC21059@kadam>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector1-analog-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jRZOazIR7In+02p6vDsRizpcnxBWx1U//h0MEIEuZuc=;
 b=Mi3Xs1RZR1Kk+9QXXdeLCo8LvH71RvweK88Lp8oOtgh22y7zUwWEHAVk/8NUHjE2KwzUQnuoX6z3YpP+BGC5DbMSAxk+Z+07rj9W/9VF7pgKWq8mzmZ/O53Qy+mJj7jhPTUQW7S5tpYn4NiZ/bCdRjZQhZSSjGo97Kg1QMa3Zxk=
In-Reply-To: <20190508122010.GC21059@kadam>
Content-Language: en-US
Content-ID: <6166AD703C20264A8933E29F0D6472FA@analog.com>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>, 
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>, 
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: "dan.carpenter@oracle.com" <dan.carpenter@oracle.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>, "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>, "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>, "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>, "andriy.shevchenko@linux.intel.com" <andriy.shevchenko@linux.intel.com>, "linux-rockchip@lists.infradead.org" <linux-rockchip@lists.infradead.org>, "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>, "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>, linux-gpio@vger.kernel.or

On Wed, 2019-05-08 at 15:20 +0300, Dan Carpenter wrote:
> 
> 
> On Wed, May 08, 2019 at 02:28:35PM +0300, Alexandru Ardelean wrote:
> > -static const char * const phy_types[] = {
> > -     "emmc 5.0 phy",
> > -     "emmc 5.1 phy"
> > -};
> > -
> >  enum xenon_phy_type_enum {
> >       EMMC_5_0_PHY,
> >       EMMC_5_1_PHY,
> >       NR_PHY_TYPES
> 
> There is no need for NR_PHY_TYPES now so you could remove that as well.
> 

I thought the same.
The only reason to keep NR_PHY_TYPES, is for potential future patches,
where it would be just 1 addition

 enum xenon_phy_type_enum {
      EMMC_5_0_PHY,
      EMMC_5_1_PHY,
+      EMMC_5_2_PHY,
      NR_PHY_TYPES
  }

Depending on style/preference of how to do enums (allow comma on last enum
or not allow comma on last enum value), adding new enum values woudl be 2
additions + 1 deletion lines.

 enum xenon_phy_type_enum {
      EMMC_5_0_PHY,
-      EMMC_5_1_PHY
+      EMM
C_5_1_PHY,
+      EMMC_5_2_PHY
 }

Either way (leave NR_PHY_TYPES or remove NR_PHY_TYPES) is fine from my
side.

Thanks
Alex

> regards,
> dan carpenter
> 
