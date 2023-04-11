From: "Kernel.org Bugbot" <bugbot-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: When processes are forked using clone3 to a cgroup in cgroup
 v2 with a specified cpuset.cpus, the cpuset.cpus doesn't take an effect to
 the new processes
Date: Tue, 11 Apr 2023 15:04:55 +0000 (UTC)
Message-ID: <20230411-b217305c1-d58d491bf9b5@bugzilla.kernel.org>
References: <20230411-b217305c0-44d643ccee27@bugzilla.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681225495;
        bh=7WIyVeb9XzClyLWUvvV5p3kO/EMToSSNiNmVoHs1IG8=;
        h=From:To:In-Reply-To:References:Subject:Date:From;
        b=UzmEBprgpf9xgOEcYRkIKoBq+QSWCf/bGHsDgkUb6V2fdMIpFEyL0j0o6ljPZPwBa
         YQTt+UrK5v2pEVdRL3J7ysjasXzLREAw9iZKfZItpVbcZQEui+3wtcAphdttbOJLyj
         08MqARvVUWewD9r3dB/6kK87s7pc7dNGRZKUO2No+BHElV2GB3dvOcfrdRMM/kpuRY
         bqj8RcOLVTkIvwaXHeNLbOMDveS8OBghipvoLgQF4ve9TDA8GkYJ9chyS/Rk1+MKbM
         wn7Wmo9SmteSvtWMLFkVR8Ry46yiDTCgIqRzwVSuUkkFmzxChrOOxKFd+DjOOxNHOS
         dxzi9XKOePnyg==
In-Reply-To: <20230411-b217305c0-44d643ccee27-590EEB7GvNiWaY/ihj7yzEB+6BGkLq7r@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, bugs-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org

tcao34 added a new attachment via Kernel.org Bugzilla.
You can download it by following the link below.

File: config-6.3.0-rc5-master (text/plain)
Size: 266.54 KiB
Link: https://bugzilla.kernel.org/attachment.cgi?id=304089
---
Config file we used

You can reply to this message to join the discussion.
-- 
Deet-doot-dot, I am a bot.
Kernel.org Bugzilla (peebz 0.1)

