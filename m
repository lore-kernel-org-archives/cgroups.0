From: Guang Yang <guangyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: throttle IO to multiple devices in one group
Date: Thu, 8 Sep 2016 16:32:32 -0700
Message-ID: <CAKtk8he8kEpbnnDL80LpigDZk-KyU6_o99D+k4iNWiUQ1AeOLQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:from:date:message-id:subject:to;
        bh=BZebQUkHJhZIc2nis1Tz1WEM+88jEiPdWvTu7bO+tvQ=;
        b=XxqNCafoEBmcf0nMFj/xWP2lcOYZG+UEDSXJVVoan5ulAdDtRfrOucRaz1xAA2t3QH
         5SJ/LIyEFtuu4X0N07FYYmmmNQY/xFEUb1nioz9k5fdTvmDhq3jRN6If4eHz+u6gYhgo
         G+HtPH2tMUeiNoKmNtGityoaYP+GL1ufmseN1MPqS0e5PKAtwEhYCRwq3KRp4pKMRYcD
         OwaCmeujh6FB1MszCWRaTk7NOLcd4tGuyqOSWt0S42Xvrz9tL0YQxCSBq/JJc4GyzsFN
         Q20f1hl9sXgiDbrENOlpP7Uscb+NKeZn6Co/voBbAwoj+8clEo6QrO7cFKoVoW0wS0+9
         BAcg==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,
We are evaluating to use cgroups to isolate different applications on
Linux. One use case of our application is that it reads/writes to
multiple block devices and we would like throttle the IO for each
application to each devices via blkio.throttle.read_iops_device.
However, it looks like each group can only configure one device.

Am I miss anything? Is there a way to support such semantic - limit
the number of reads to multiple devices within one group?

Thanks very much.
