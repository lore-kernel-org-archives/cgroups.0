From: Domenico Cerasuolo <cerasuolodomenico-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0/3] selftests: cgroup: add zswap test program
Date: Wed, 21 Jun 2023 17:35:45 +0200
Message-ID: <20230621153548.428093-1-cerasuolodomenico@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687361753; x=1689953753;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=yLC3Qvm8n/w4CH5ToSb5DN8Odh2TdBdFkjR985bJsFU=;
        b=XNNg4geRz6v9Rne19hZvE7dAvG7m5JVqo482JTQxpuo2aiaamcJHYjpGzn/hDYhn4R
         34MbwzgM88Y7NgENR6uA17UWiK/FzRBMbt1DFnUdf/mnGNQNinfxbqTCgaBInMhCjq/6
         iDIClLNEKaInpZedkWU6pP+zF1LqhgBnl4dg2ZXMBVZ/R6gsIStjaGRbimg/YBE0791l
         65L7T1AnG/c1WBy3tN6kQkfY+SaHhzvlga+WLowV4xjOg8hXtcaUv89A8tFbU3d0h1Ny
         BdRGtaLRnrf+kWj5Lxx6BX30XOo9xbnOVazlq7DRD/evPGoK0K+t6rOCUa7/slGjr6Z2
         w+Vg==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, sjenning-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ddstreet-EkmVulN54Sk@public.gmane.org, vitaly.wool-OWPKS81ov/FWk0Htik3J/w@public.gmane.org, riel-ebMLmSuQjDVBDgjK7y7TUQ@public.gmane.org, nphamcs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Domenico Cerasuolo <cerasuolodomenico-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

This series adds 2 zswap related selftests that verify known and fixed
issues. A new dedicated test program (test_zswap) is proposed since
the test cases are specific to zswap and hosts specific helpers.

The first patch adds the (empty) test program, while the other 2 add an
actual test function each.

Domenico Cerasuolo (3):
  selftests: cgroup: add test_zswap program
  selftests: cgroup: add test_zswap with no kmem bypass test
  selftests: cgroup: add zswap-memcg unwanted writeback test

 tools/testing/selftests/cgroup/.gitignore   |   1 +
 tools/testing/selftests/cgroup/Makefile     |   2 +
 tools/testing/selftests/cgroup/test_zswap.c | 286 ++++++++++++++++++++
 3 files changed, 289 insertions(+)
 create mode 100644 tools/testing/selftests/cgroup/test_zswap.c

-- 
2.34.1

