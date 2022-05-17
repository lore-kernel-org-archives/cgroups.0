From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v3] blk-cgroup: always terminate io.stat lines
Date: Tue, 17 May 2022 06:12:04 -0600
Message-ID: <165278952418.12941.4325264956300231225.b4-ty@kernel.dk>
References: <20220111083159.42340-1-w.bumiller@proxmox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=bESFS7Lce2ivS8jPv+1Tsk70w8y9oJwx0ecowrteEFU=;
        b=Y/MfMz7lk/eOpLKlFlTXgPsjibZmZaA2PbI2ucwBhDPfX/hEp9tUApYImhcgzuuYOF
         FOt0+nc+MCLbeqbOXV3FgGF3xcRDDx1sxrxkzBONsxm444eMwKGqx9Wj7nayWIJL9beT
         2QbsV6YhW75anjz5V+Xj6lKrjs26H0gANnVDdG960Z/4Y/C8knzq0Y9I2vc/PpdEnMeZ
         Er8qwMap1HyKGi9GB839aP0LGjuJNKfmJ+iP10ioCUykBwDlM0Dhj848G3NO13ISNqHw
         FbbnrNHoZK1jN2MLWHhJf/T5K2MCHbpv7+Up7vjLRjEbLdk+KUvjpfSqkW4LP1W0oWmi
         saGA==
In-Reply-To: <20220111083159.42340-1-w.bumiller@proxmox.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: w.bumiller@proxmox.com, linux-block@vger.kernel.org
Cc: tj@kernel.org, Christoph Hellwig <hch@lst.de>, t.lamprecht@proxmox.com, cgroups@vger.kernel.org

On Tue, 11 Jan 2022 09:31:59 +0100, Wolfgang Bumiller wrote:
> With the removal of seq_get_buf in blkcg_print_one_stat, we
> cannot make adding the newline conditional on there being
> relevant stats because the name was already written out
> unconditionally.
> Otherwise we may end up with multiple device names in one
> line which is confusing and doesn't follow the nested-keyed
> file format.
> 
> [...]

Applied, thanks!

[1/1] blk-cgroup: always terminate io.stat lines
      commit: 3607849df47822151b05df440759e2dc70160755

Best regards,
-- 
Jens Axboe


