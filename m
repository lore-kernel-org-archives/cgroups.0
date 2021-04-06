From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 00/11] treewide: address gcc-11 -Wstringop-overread warnings
Date: Tue,  6 Apr 2021 00:53:17 -0400
Message-ID: <161768454091.32082.3141021591391350544.b4-ty@oracle.com>
References: <20210322160253.4032422-1-arnd@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=z6WUpdpP7QuueY+6HVjqRyjPlcWvW85PeHWksryxc1s=;
 b=SZgD5nxpzoPP5BC/kCwEtImG++GGuRJ0VsqbamZHDVSVjgaRvtQ/6rVKOY+yEZKEyaDO
 CLcSPT2WMzlgk+oCe9lnQfwmIRFUHkunczw22nyPnuFT6fXAHjB83QuQW3E2d7pZPU27
 qySJdDM8rjLgOxzYD1La6zZp+F/nwteSl4OYbk7olbPnzAjewLgFZSYSJsh9HT4yO9fg
 gYkYZzp1l4shtyjVdZHLIUk754lEP7qacfu8Z0Ruf2YDZNAUt8e3yOlNDRuTk1xliiih
 TH0fIDyeCY2obmPG7Ajwy80lBmEYoL5EpSc0onIHDnrXjlstWlEZ00Hee+afFMCDS6bP 9Q== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z6WUpdpP7QuueY+6HVjqRyjPlcWvW85PeHWksryxc1s=;
 b=d8dNvvSXzSsDMO6sC7yDvuKOp/gJV3ecOQzOQPp5O2/jZPQE7A53hdLOFYygRW8DLoGoYFVHzeqRK9yCO8B14byUHVGUWJJ2W+OasQyi0zfXgDxuNIw/p3mYFpaj2yRzZp0HArxHhc3nAKGKrN9oI/hgzaxCNK8dUiv+C525g/E=
In-Reply-To: <20210322160253.4032422-1-arnd@kernel.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-kernel@vger.kernel.org, Martin Sebor <msebor@gcc.gnu.org>, Arnd Bergmann <arnd@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, x86@kernel.org, linux-scsi@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-wireless@vger.kernel.org, tboot-devel@lists.sourceforge.net, ath11k@lists.infradead.org, linux-arm-kernel@lists.infradead.org, Anders Larsen <al@alarsen.net>, netdev@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, "James E.J. Bottomley" <jejb@linux.ibm.com>, cgroups@vger.kernel.org, linux-security-module@vger.kernel.org, Serge Hallyn <serge@hallyn.com>, Imre Deak <imre.deak@intel.com>, Simon Kelley <simon@thekelleys.org.uk>, Ning Sun <ning.sun@intel.com>, Tejun Heo <tj@kernel.org>, intel-gfx@lists.freedesktop.org, Jani Nikula <jani.nikula@linux.intel.com>, James Smart <james.smart@broadcom.com>, Kalle Valo <kvalo@codeaurora.org>

On Mon, 22 Mar 2021 17:02:38 +0100, Arnd Bergmann wrote:

> The coming gcc release introduces a new warning for string operations
> reading beyond the end of a fixed-length object. After testing
> randconfig kernels for a while, think I have patches for any such
> warnings that came up on x86, arm and arm64.
> 
> Most of these warnings are false-positive ones, either gcc warning
> about something that is entirely correct, or about something that
> looks suspicious but turns out to be correct after all.
> 
> [...]

Applied to 5.13/scsi-queue, thanks!

[09/11] scsi: lpfc: fix gcc -Wstringop-overread warning
        https://git.kernel.org/mkp/scsi/c/ada48ba70f6b

-- 
Martin K. Petersen	Oracle Linux Engineering
