From: Anthony Ananich <anton.ananich-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: How to avoid rebuilding cgroup quotas after moving VPS to a different hypervisor
Date: Sun, 4 Dec 2016 11:12:26 +0300
Message-ID: <1A3D5B84-0ECC-4EBA-8FC4-E3B291787DDA@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:content-transfer-encoding:subject:message-id:date:to
         :mime-version;
        bh=rbyWCsq0TxDVowgC2oPbomEI5XudYLl0SHUZYwwMl3M=;
        b=YnVemQkalto5wGsyq71MAOTHxkEE+fcY4iK0ipf9CJvB7Epd+hDEEw2qEuUcTlZGuh
         VYnOQhnm28iLeTGM5R6NvhPOFp7TfKOus/+jRFTS58T9XhjiW7+ZIk2CC5RVpQcEiwQG
         LZ2MzYkAxtOB93Drzxdn0wM7y56bVNS8AieRgbLYvfzvjrAFhVJefYzlXmnF0153q0Bz
         lu86SQnlRMnI2Zn/4Mh3llB0PMmxgzBXJszxnW1aCSaoPjo+b9srqyiu5MiaXvIRWbD7
         wlm2ZemoC6hjO4nCXQDIDbhdHWZUHxumwL7dD8ToGzxyXZHadlZ4u628dWmqGlh7xkEU
         3UPw==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Dear All,

I have a virtual server with two-core 2GHz CPU. There are several =
applications running, each one in a separate cgroup. I need to limit CPU =
usage, so I set period=3D1000000 and quota=3D1000000 for every cgroup. =
This way each cgroup gets 2GHz.

The problem comes when I need to scale. After I move this virtual server =
to an another hypervisor with four-core 3Ghz CPU, every cgroup now have =
3GHz quota. And I have to rebuild all of my configs.

Is there a way to specify CPU quota in absolute values? Is it actually =
possible?

Regards,
Anthony Ananich
http://ananich.pro
