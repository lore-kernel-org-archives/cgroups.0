From: "R. Diez" <rdiez1999-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Wrapper to run a command in a temporary cgroup
Date: Mon, 4 Apr 2022 14:25:27 +0200
Message-ID: <0174490d-8679-3885-df31-e9f6c1e7205b@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:to:content-language:from
         :subject:content-transfer-encoding;
        bh=SYa0Jf1JBf+hKoQ5XoVsa6vRKIe3ItAJl54XdHPKelM=;
        b=VqoMexCOiLjUKiVT1lWCXyjxxD4aXjBjLcBbFqK72xiu3O4VU4/8rVIhnwoaLv7omC
         pwIRFAwlYL9tENq8rzVmlAW0OifAyBOKSlPEW6iKXLFJqQEmHXj0oT2AEnJpsNrq/hl6
         eAyo0xSviPluO9T3fhM1pI3zyvbttdRiIsDVfxH/Iyge40abdhGgt5A0vkkbYGcOVf3p
         FhCaYpOke/1wMN71OO4lna7IqSNFFFE+OYoJYTaL8w5eXmhaqI6ze7eT3qbEqw9QYSGD
         ih0KW7/qHWIGkXO2s2ZICXD1d0ChI41RWg+HN/eaNxT7gsUL+nntqy5DP+v1J3cnvbML
         YTQQ==
Content-Language: en-GB
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: cgroups mailinglist <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi all:

I am looking for a wrapper script like this:

run-on-temporary-cgroup.sh cmd arg1 ... argn.

The tool should create a temporary cgroup, run the process inside, and return the same exit code as the user command.

I may want to limit the amount of memory the cgroup is allowed to consume. But more importantly, I want the tool to return when all processes in the cgroup (the user command an any children) have already terminated. This is apparently not so easy to achieve without cgroups.

Those requirements are similar to what systemd-run does, but I need an alternative which does not depend on systemd.

Even if you have systemd, systemd-run is rather convenient, but it is somewhat heavy weight and it has issues with some signals (like SIGTERM), and with escaping/quoting, depending on the mode (--scope vs --wait).

If there is no such a tool, can someone give me some hints on how to implement one? Is it possible in Shell or Perl? Or do I need to reach to C / C++? Is there anything similar I could take as basis?

Apologies if this is not the right mailing list. I could not find anywhere else to ask about cgroups matters.

Regards,
   rdiez
