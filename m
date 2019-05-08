From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH 09/16] mmc: sdhci-xenon: use new match_string()
 helper/macro
Date: Wed, 8 May 2019 15:20:10 +0300
Message-ID: <20190508122010.GC21059@kadam>
References: <20190508112842.11654-1-alexandru.ardelean@analog.com>
 <20190508112842.11654-11-alexandru.ardelean@analog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com;
 h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=Vy0vJPC+R/qK4BTy9W8k2EK+1DkuBwwYmX4Im7RV/1I=;
 b=rwrtMH5vFY76MnriFuwWJRty7cv6d48ndLvoH9qa0iSpe18cQhaRn84K+EEAZ1el4f/y
 JYXzNPHiRG6Um3c2LeXmrh0vIUgokB68rrApoaQDWIhQiq3xdWk5gSEBW5t2CsNm+NQD
 vMj6o0elaMb6F0MU58KC4FWtRSn89CRe22TBfRL7zCGITD8/HSnJoDvmL6xh8b//HGVN
 0/+i+9yb5Er16ot7xGaUWYdgVLnSKYTBDh5U+VgaaiAGanyy3YqtlO3+pRPaxxQxAHqK
 Taf9LSC6aD/fmeyve7zi016PT3fCR2HgfwqDVjH/4iBaBbfLBHPj+ptzQwZZXQN8uHEa Qg== 
Content-Disposition: inline
In-Reply-To: <20190508112842.11654-11-alexandru.ardelean@analog.com>
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
To: Alexandru Ardelean <alexandru.ardelean@analog.com>
Cc: linux-fbdev@vger.kernel.org, kvm@vger.kernel.org, linux-pci@vger.kernel.org, alsa-devel@alsa-project.org, dri-devel@lists.freedesktop.org, linux-ide@vger.kernel.org, linux-mtd@lists.infradead.org, linux-clk@vger.kernel.org, devel@driverdev.osuosl.org, andriy.shevchenko@linux.intel.com, linux-rockchip@lists.infradead.org, linux-mmc@vger.kernel.org, linux-pm@vger.kernel.org, intel-gfx@lists.freedesktop.org, linux-gpio@vger.kernel.org, linux-rpi-kernel@lists.infradead.org, linux-tegra@vger.kernel.org, cgroups@vger.kernel.org, linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, netdev@vger.kernel.org, linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, gregkh@linuxfoundation.org, linux-integrity@vger.kernel.org, linuxppc-dev@lists.ozlabs.org

On Wed, May 08, 2019 at 02:28:35PM +0300, Alexandru Ardelean wrote:
> -static const char * const phy_types[] = {
> -	"emmc 5.0 phy",
> -	"emmc 5.1 phy"
> -};
> -
>  enum xenon_phy_type_enum {
>  	EMMC_5_0_PHY,
>  	EMMC_5_1_PHY,
>  	NR_PHY_TYPES

There is no need for NR_PHY_TYPES now so you could remove that as well.

regards,
dan carpenter
