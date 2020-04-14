From: Timo Haas <haastimo-Mmb7MZpHnFY@public.gmane.org>
Subject: Documentation cgroups v1
Date: Tue, 14 Apr 2020 20:56:17 +0200
Message-ID: <b8577be4-18d5-4e81-8f59-6b4ad68e9f10@gmx.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1586890578;
        bh=+Tdr2K02RJI+GpvSdoZWt162/aAc9VhDfCwMAjh/zRQ=;
        h=X-UI-Sender-Class:To:From:Subject:Date;
        b=To6+SlucjMC+NnMnolrmspIqPDfcmfdtkJM0Od0mT1wnzsV70RQI4qgrnC5rkCZa0
         P1XDBbxOg4KLmKxxhhrO9Y2G5Jou6NG0l5nGkTLO9XFcx8is0qCBzBt/6+MiCeUmoF
         WwaDO0DTnczL3MEP38bv/mkPH4IEb+u1hat9egfk=
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi

I've got a question: The cgroups-v1 documentation doesn't mention
anymore the status of recording blkio.io_serviced and
blkio.io_service_bytes stats when files are written without the O_DIRECT
flag within a subgroup. With cgroups v2 it can be accurately recorded if
the filesystem supports it. What is the status in cgroups v1?

I assume it has not changed and it can't keep the stats because there is
no communication with the memory controller. Or have the improvements
made in cgroups v2 ported to cgroups v1?

Background: [1] added documentation on limitations of blkio stats
collection in cgroups v1.
[2] refactored the documentation and I think mistakenly deleted too much.

Thanks
	Timo Haas

[1]
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/Documentation/cgroups/blkio-controller.txt?h=v4.14-rc4&id=3e1534cf4a2a8278e811e7c84a79da1a02347b8b
[2]
https://git.kernel.org/pub//scm/linux/kernel/git/torvalds/linux.git/commit/?id=6c2920926b10e8303378408e3c2b8952071d4344
