From: Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [PATCH 04/11] ath11: Wstringop-overread warning
Date: Tue, 28 Sep 2021 09:04:02 +0000 (UTC)
Message-ID: <20210928090402.42913C43638@smtp.codeaurora.org>
References: <20210322160253.4032422-5-arnd@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1632819870; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=09C7+Iq0CKL2hGEdanYSFMJLK30HPDjpfQExa8Wp094=;
 b=DHEeRTdIHZjKC/Bunjchtq8WT41KPhc4Xp1bz3CktbEFbwRNpaDlSHLLq+C7csJDutrcTG3b
 oydPYoZKTba1ElOf8E8DCgDb1s3n57tZAacZ6hHqAYUoFDsHS1P7DJhVJHurrhTwFOie7Hf9
 u5btYudTGZCGYHYfa0001pZDjVg=
Sender: kvalo=codeaurora.org@mg.codeaurora.org
In-Reply-To: <20210322160253.4032422-5-arnd@kernel.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Arnd Bergmann <arnd@kernel.org>
Cc: linux-kernel@vger.kernel.org, Martin Sebor <msebor@gcc.gnu.org>, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, Arnd Bergmann <arnd@arndb.de>, x86@kernel.org, Ning Sun <ning.sun@intel.com>, Jani Nikula <jani.nikula@linux.intel.com>, Simon Kelley <simon@thekelleys.org.uk>, James Smart <james.smart@broadcom.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, Anders Larsen <al@alarsen.net>, Tejun Heo <tj@kernel.org>, Serge Hallyn <serge@hallyn.com>, Imre Deak <imre.deak@intel.com>, linux-arm-kernel@lists.infradead.org, tboot-devel@lists.sourceforge.net, intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, ath11k@lists.infradead.org, linux-wireless@vger.kernel.org, netdev@vger.kernel.org, linux-scsi@vger.kernel.org, cgroup

Arnd Bergmann <arnd@kernel.org> wrote:

> gcc-11 with the kernel address sanitizer prints a warning for this
> driver:
> 
> In function 'ath11k_peer_assoc_h_vht',
>     inlined from 'ath11k_peer_assoc_prepare' at drivers/net/wireless/ath/ath11k/mac.c:1632:2:
> drivers/net/wireless/ath/ath11k/mac.c:1164:13: error: 'ath11k_peer_assoc_h_vht_masked' reading 16 bytes from a region of size 4 [-Werror=stringop-overread]
>  1164 |         if (ath11k_peer_assoc_h_vht_masked(vht_mcs_mask))
>       |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/net/wireless/ath/ath11k/mac.c: In function 'ath11k_peer_assoc_prepare':
> drivers/net/wireless/ath/ath11k/mac.c:1164:13: note: referencing argument 1 of type 'const u16 *' {aka 'const short unsigned int *'}
> drivers/net/wireless/ath/ath11k/mac.c:969:1: note: in a call to function 'ath11k_peer_assoc_h_vht_masked'
>   969 | ath11k_peer_assoc_h_vht_masked(const u16 vht_mcs_mask[NL80211_VHT_NSS_MAX])
>       | ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> According to analysis from gcc developers, this is a glitch in the
> way gcc tracks the size of struct members. This should really get
> fixed in gcc, but it's also easy to work around this instance
> by changing the function prototype to no include the length of
> the array.
> 
> Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=99673
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

eb19efed836a ath11k: Wstringop-overread warning

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210322160253.4032422-5-arnd@kernel.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

