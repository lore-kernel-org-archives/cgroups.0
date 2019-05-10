From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH 09/16] mmc: sdhci-xenon: use new match_string()
 helper/macro
Date: Fri, 10 May 2019 14:01:17 +0300
Message-ID: <20190510110116.GB18105@kadam>
References: <20190508112842.11654-1-alexandru.ardelean@analog.com>
 <20190508112842.11654-11-alexandru.ardelean@analog.com>
 <20190508122010.GC21059@kadam>
 <2ec6812d6bf2f33860c7c816c641167a31eb2ed6.camel@analog.com>
 <31be52eb1a1abbc99a24729f5c65619235cb201f.camel@analog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com;
 h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=CfM0QyoiD2lceMf/MJC3mMjfCfXAd2/bfEOAWv0cJ2Q=;
 b=D51Bv0We8QTowc99zvTCIJuTCbSCXoc9B56Z8ExvQIyI9tdem+W93bgyBgMXVwunZ8pv
 4kxXOENcN94heTpPe2HdMrlJB2T3qCmEYwsZdQFLCZzVl7iwnIcB0+tOsj8a33pcDZ2b
 apaVZ8tiLXNzMfnoXrAtpjl+jnRLf4c9KQWuZg+PnEEgt/vdDBqRhVHpu/5TuzfI6BfK
 fi+8tUJU/aJFGtgdSqiKUrW3X2rQyYClgjiNr0e4R6bCAQx6tWNkz5Uq/nnWCSvgOzQY
 +Vw2Uu/Wf73/Oj/IUlLw1hBGhDnT3dAWjKij3V31FPg//vP2lgc79WQPCO9s4WRRuFde AQ== 
Content-Disposition: inline
In-Reply-To: <31be52eb1a1abbc99a24729f5c65619235cb201f.camel@analog.com>
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
To: "Ardelean, Alexandru" <alexandru.Ardelean@analog.com>
Cc: "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>, "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>, "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>, "andriy.shevchenko@linux.intel.com" <andriy.shevchenko@linux.intel.com>, "linux-rockchip@lists.infradead.org" <linux-rockchip@lists.infradead.org>, "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>, "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>, "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>, linux-gpio@vger.kerne

On Fri, May 10, 2019 at 09:13:26AM +0000, Ardelean, Alexandru wrote:
> On Wed, 2019-05-08 at 16:26 +0300, Alexandru Ardelean wrote:
> > On Wed, 2019-05-08 at 15:20 +0300, Dan Carpenter wrote:
> > > 
> > > 
> > > On Wed, May 08, 2019 at 02:28:35PM +0300, Alexandru Ardelean wrote:
> > > > -static const char * const phy_types[] = {
> > > > -     "emmc 5.0 phy",
> > > > -     "emmc 5.1 phy"
> > > > -};
> > > > -
> > > >  enum xenon_phy_type_enum {
> > > >       EMMC_5_0_PHY,
> > > >       EMMC_5_1_PHY,
> > > >       NR_PHY_TYPES
> > > 
> > > There is no need for NR_PHY_TYPES now so you could remove that as well.
> > > 
> > 
> > I thought the same.
> > The only reason to keep NR_PHY_TYPES, is for potential future patches,
> > where it would be just 1 addition
> > 
> >  enum xenon_phy_type_enum {
> >       EMMC_5_0_PHY,
> >       EMMC_5_1_PHY,
> > +      EMMC_5_2_PHY,
> >       NR_PHY_TYPES
> >   }
> > 
> > Depending on style/preference of how to do enums (allow comma on last
> > enum
> > or not allow comma on last enum value), adding new enum values woudl be 2
> > additions + 1 deletion lines.
> > 
> >  enum xenon_phy_type_enum {
> >       EMMC_5_0_PHY,
> > -      EMMC_5_1_PHY
> > +      EMM
> > C_5_1_PHY,
> > +      EMMC_5_2_PHY
> >  }
> > 
> > Either way (leave NR_PHY_TYPES or remove NR_PHY_TYPES) is fine from my
> > side.
> > 
> 
> Preference on this ?
> If no objection [nobody insists] I would keep.
> 
> I don't feel strongly about it [dropping NR_PHY_TYPES or not].

If you end up resending the series could you remove it, but if not then
it's not worth it.

regards,
dan carpenter
